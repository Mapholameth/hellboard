<%def name="post(post)">
  <div class="post" id="post-${post.id}" data-id="${post.id}">      
    <div class="post-header">
    	<span class="post-header-block">
    		<a class="post-anchor" name="${post.id}">${post.id}</a>
    	</span>
    	<span class="post-header-block post-datetime">${post.postingDateTime}</span>
    	<span class="post-header-block delete-post" data-id="${post.id}">X</span>
    </div>
    <div class="post-content">
      ${post.formatted_text or u'' | n}
    </div>
  </div>
</%def>