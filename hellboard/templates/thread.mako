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

      $("a").addClass("postref");

      var postAnswers = {};

      $("a:regex(href,^/#\\d+$)").each(function(index, element){
        var pat1 = new RegExp("^/#(\\d+)$");
        var pat2 = new RegExp("^Post(\\d+)$");
        var id = pat1.exec($(this).attr("href"))[1];
        var parentId = pat2.exec($(this).parent().attr("id"))[1];

        if ( postAnswers[id] == undefined )
          postAnswers[id] = {};
        postAnswers[id][parentId] = true;
      });

      for (var k in postAnswers)
      {
        var post = $(":regex(id,^Post" + k + "$)");
        post.append("<br/>");
        for (var j in postAnswers[k])
        {
          post.append("<a class = \"answerref\" href = \"/#" + j + "\">&gt;&gt;" + j  + "</a> ");
        }
      }      

      //console.log(postAnswers);

      $("a:regex(href,^/#\\d+$)").click(function(){
        var href = $(this).attr("href");
        var pat = new RegExp("^/#(\\d+)$");
        var id = pat.exec(href);
        var post = $(":regex(id,^Post" + id[1] + "$)");
        post.clearQueue();
        post.animate({ "background-color" : "#ffffff" }, 10);
        post.animate({ "background-color" : "#bbbbee" }, 50);
        post.animate({ "background-color" : "#ffffff" }, 50);
        post.animate({ "background-color" : "#bbbbee" }, 50);
        post.animate({ "background-color" : "#ffffff" }, 50);
        post.animate({ "background-color" : "#bbbbee" }, 50);
        post.animate({ "background-color" : "#ffffff" }, 50);
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