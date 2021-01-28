import 'imba/preflight.css'

import store from './store'

global css body
	m:0 p:0
	ff:sans
	$orange: #ff6602
	$beige: #f6f6ef
	bg:$beige
	a c:inherit td:none @hover:underline cursor:pointer

tag story-item < li
	
	<self[d:hflex p:1] [o:0.3]=!data.loaded @intersect.silent.in=(data.load!)>
		<.nr[c:gray6 w:>40px ja:center d:flex]> "1"
		<.main[fl:1 px:1]>
			<div[fs:md].title>
				<span> data.title or "Loading..."
				if data.url
					<span[c:gray8/70 ml:1 fs:sm]> "({<a href=data.url.href> data.url.hostname})"

			<div[c:gray8/70 fs:sm-]>
				css span + span prefix: " | "

				<span.score> "{data.score} points by {<a href="/user?id={data.by}"> data.by}"

				let count = data.descendants or 0
				let label = ['discuss','1 comment'][count] or "{count} comments"
				<span.comments> <a[td@hover:underline]> label

tag stories
	def mount
		data = await store.fetch(api-url)
		data.preload(0,15)

	<self> <ul> for item in data
		<story-item data=item>

tag App
	<self>
		<header[bg:$orange h:8 d:hflex ja:center]>
			css a px:1 c.active:white
			<a route-to='/top'> "Top"
			<a route-to='/newest'> "New"
			<a route-to='/show'> "Show"
			<a route-to='/ask'> "Ask"
			<a route-to='/jobs'> "Jobs"
		<main>
			<stories route='/top' api-url='topstories'>
			<stories route='/newest' api-url='newstories'>
			<stories route='/show' api-url='showstories'>
			<stories route='/ask' api-url='askstories'>
			<stories route='/jobs' api-url='jobstories'>

imba.router.alias('/', '/top')
imba.mount <App>