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
        for(x in this)
        {
          console.log( x, this[x] );
        }
        console.log(this[name]);
        $(this).css("background", "#bbbbee" );
      });

      $(".button").click(function(){
        var input_string = $("input#posttext");
        console.log(input_string);
        $.ajax({
          type: "POST",
          data: { textfield : "asdf" },
          success: function(data){
            console.log(data);
            $('#footer').html(data).hide().fadeIn(1500);
          },
        });
      });
    });
  </script>


</head>

<body>
  % for item in pages:
  <div class="wrapper" id="Post${item.id}">
    <div class="postheader">
        <a name="${item.id}">${item.id}</a>
    </div>
    ${item.formatted_text or u'' | n}
  </div>
  % endfor

  <div class="postform">
    <form action="" method="post">
      <textarea name="body" rows="10" id="posttext"></textarea>
      <input type="submit" name="form.submitted" value="Post"/>
      <input class="button" type="button" value="test"/>
    </form>
  </div>

  <footer id = "footer">
  </footer>

</body>

</html>