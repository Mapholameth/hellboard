<%inherit file="main.mako"/>

<%block name="content">
  <%namespace name="post" file="post.mako"/>
  % for item in posts:
    ${post.post(post=item)}
  % endfor
  <%include file="postform.mako"/>
</%block>