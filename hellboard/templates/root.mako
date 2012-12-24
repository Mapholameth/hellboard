<!DOCTYPE HTML>
<html>
<head>
  <title>threads</title>

  <meta http-equiv="Content-Type"
        content="text/html; charset=UTF-8"/>

  <link rel="shortcut icon"
        href="${request.static_url('hellboard:static/favicon.ico')}"/>

  <link rel="stylesheet"
        href="${request.static_url('hellboard:static/chugun.css')}"
        type="text/css"
        media="screen"
        charset="utf-8"/>

  <script type="text/javascript"
          src="${request.static_url('hellboard:static/jquery.js')}"></script>

  <script type="text/javascript"
          src="${request.static_url('hellboard:static/jquery.color.js')}"></script>

  <script type="text/javascript">

    $(document).ready(function(){

      $(".post").click(function(e){        
        board = $(this).find(".post-content").html();
        $('<form action="/' + board + '" method="POST">' + 
          '<input type="hidden" name="view" value="' + $(this).attr('data-id') + '">' +
          '</form>').submit();
      });

    });
  </script>

  <title>Boards</title>

</head>

<body>

  <div id="left-sidebar">
  </div>

  <div id="content">
    % for item in boards:
    <div class="post" id="post-${item.id}" data-id="${item.id}">      
      <div class="post-header">
          <a class="post-anchor" name="${item.id}">${item.id}</a>
          <div class="delete-post" data-id="${item.id}">X</div>
      </div>
      <div class="post-content">${item.name or u'' | n}</div>
    </div>
    % endfor
  </div>

  <footer id="footer">
  </footer>

</body>

</html>