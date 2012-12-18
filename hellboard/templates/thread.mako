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

      $("a:regex(href,^/#\\d+$)").addClass("postref");

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

      $("a.postref:regex(href,^/#\\d+$)").click(function(){
        var href = $(this).attr("href");
        var pat = new RegExp("^/#(\\d+)$");
        var id = pat.exec(href)[1];
        var post = $(":regex(id,^Post" + id + "$)");
        if (!post.is(":visible"))
        {
          $(post).show();
        }            

        post.clearQueue();
        post.animate({ "background-color" : "#ffffff" }, 10);
        post.animate({ "background-color" : "#bbbbee" }, 50);
        post.animate({ "background-color" : "#ffffff" }, 50);
        post.animate({ "background-color" : "#bbbbee" }, 50);
        post.animate({ "background-color" : "#ffffff" }, 50);
        post.animate({ "background-color" : "#bbbbee" }, 50);
        post.animate({ "background-color" : "#ffffff" }, 50);
      });



      $("a.answerref").click(function(){
        var href = $(this).attr("href");
        var pat = new RegExp("^/#(\\d+)$");
        var id = pat.exec(href)[1];
        var post = $(":regex(id,^Post" + id + "$)");
        post.clearQueue();
        post.animate({ "background-color" : "#ffffff" }, 10);
        post.animate({ "background-color" : "#eebbbb" }, 50);
        post.animate({ "background-color" : "#ffffff" }, 50);
        post.animate({ "background-color" : "#eebbbb" }, 50);
        post.animate({ "background-color" : "#ffffff" }, 50);
        post.animate({ "background-color" : "#eebbbb" }, 50);
        post.animate({ "background-color" : "#ffffff" }, 50);
      });

      $(".wrapper").click(function(){
        var pat2 = new RegExp("^Post(\\d+)$");
        var id = pat2.exec($(this).attr("id"))[1];

        if(!postAnswers[id])
          return;

        var that = this;     

        var minId = parseInt(id);
        var maxId = parseInt(id);
        for (var k in postAnswers[id])
        {
            if (parseInt(k) < minId)
              minId = k;
            if (parseInt(k) > maxId)
              maxId = k;
        };

        $(".wrapper").each(function(){
          var id2 = pat2.exec($(this).attr("id"))[1];
          if(!postAnswers[id][id2] && this!=that)
          {
            if (parseInt(id2) > parseInt(minId) && parseInt(id2) < parseInt(maxId))
            {
              $(this).hide();
            }
          }
          else if ( this != that )
          {
            var offset = 20;
            if (!$(this).is(":visible"))
            {
              offset += parseInt($(that).css("left"));
            }
            $(this).show();
            $(this).clearQueue();
            $(this).animate({ "left" : offset + "px" }, 50);

            $(this).animate({ "background-color" : "#ffffff" }, 10);
            $(this).animate({ "background-color" : "#eebbbb" }, 50);
            $(this).animate({ "background-color" : "#ffffff" }, 50);
            $(this).animate({ "background-color" : "#eebbbb" }, 50);
            $(this).animate({ "background-color" : "#ffffff" }, 50);
            $(this).animate({ "background-color" : "#eebbbb" }, 50);
            $(this).animate({ "background-color" : "#ffffff" }, 50);

          }
        });
      });

      $("#leftSidebar").click(function(){
          $(".wrapper").each(function(){
            $(this).show();
            $(this).animate({ "left" : "0px" }, 50);
          });

      });

    });
  </script>


</head>

<body>

  <div id="leftSidebar"></div>
  <div id="content">
    % for item in pages:
    <div class="wrapper" id="Post${item.id}">
      <div class="postheader">
          <a name="${item.id}">${item.id}</a>
      </div>
      ${item.formatted_text or u'' | n}
    </div>
    % endfor    
  </div>  

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