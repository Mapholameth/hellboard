<%include file="main.mako"/>

<%block name="content">
  <%namespace name="post" file="post.mako"/>
  % for item in threads:
  	% for postItem in item['posts']:
    ${post.post(post=postItem)}
    % endfor
  % endfor
  <%include file="postform.mako"/>
</%block>