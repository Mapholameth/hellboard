<!DOCTYPE HTML>
<html>
<head>
  <title>threads</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <link rel="shortcut icon"
        href="${request.static_url('hellboard:static/favicon.ico')}" />
  <link rel="stylesheet"
        href="${request.static_url('hellboard:static/chugun.css')}"
        type="text/css" media="screen" charset="utf-8" />
  <title>Your Website</title>

  <script type="text/javascript" src="${request.static_url('hellboard:static/jquery.js')}"></script>

  <script type="text/javascript">
    $(document).ready(function(){
      $("a").click(function(){
        $("a[name]").css("background", "#eee" );
      });
    });
  </script>


</head>

<body>

    <section>

      % for item in pages:
      <div class="wrapper">
              <div class="ribbon-wrapper-green"><div class="ribbon-green"><a name=${item.id}>${item.id}</a></div></div>
              ${item.formatted_text or u'' | n}
      </div>
      % endfor

      <div class="postform">
        <form action="" method="post">
          <textarea name="body" rows="10" cols="60"></textarea>
          <input type="submit" name="form.submitted" value="Post"/>
        </form>
      </div>

    </section>
  <footer id = "footer">
  </footer>

</body>

</html>