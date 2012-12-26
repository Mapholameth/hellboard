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

  <script type="text/javascript"
          src="${request.static_url('hellboard:static/hellboard.js')}"></script>

  <title>Hellboard</title>

</head>

<body>

  <div id="left-sidebar">
    <div class="navigation">
      <a href="/">Главня страница</a>
      <ul>
        % for item in boards:
          <li>
            <a href="/${item.name}">${item.title}</a> 
          </li>
        % endfor
      </ul>
    </div>
  </div>

  <div id="content">
    <%block name="content"/>
  </div>

  <footer id="footer">
  </footer>

</body>

</html>