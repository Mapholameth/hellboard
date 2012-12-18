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
  <script type="text/javascript" src="${request.static_url('hellboard:static/jquery.color.js')}"></script>

  <script type="text/javascript">

    jQuery.expr[':'].regex = function(elem, index, match) {
      var matchParams = match[3].split(','),
          validLabels = /^(data|css):/,
          attr = {
              method: matchParams[0].match(validLabels) ? 
                          matchParams[0].split(':')[0] : 'attr',
              property: matchParams.shift().replace(validLabels,'')
          },
          regexFlags = 'ig',
          regex = new RegExp(matchParams.join('').replace(/^\s+|\s+$/g,''), regexFlags);
      return regex.test(jQuery(elem)[attr.method](attr.property));
    }

    $(document).ready(function(){

      $("a:regex(href,^/#\\d+$)").click(function(){
        var href = $(this).attr("href");
        var pat = new RegExp("^/#(\\d+)$");
        var id = pat.exec(href);
        var post = $(":regex(id,^Post" + id[1] + "$)");
        post.animate({ "background-color" : "#ffffff" }, 50);
        post.animate({ "background-color" : "#bbbbee" }, 200);
        post.animate({ "background-color" : "#ffffff" }, 200);
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