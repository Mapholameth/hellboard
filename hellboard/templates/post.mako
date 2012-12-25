<%def name="post(post)">
  <div class="post" id="post-${post.id}" data-id="${post.id}">      
    <div class="post-header">
        <a class="post-anchor" name="${post.id}">${post.id}</a>
        <div class="delete-post" data-id="${post.id}">X</div>
    </div>
    <div class="post-content">
      ${post.formatted_text or u'' | n}
    </div>
  </div>
</%def>