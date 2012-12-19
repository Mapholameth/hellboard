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

    var HighlightPost = function(post)
    {
      post.animate({ "background-color" : "#ffffff" }, 10);
      post.animate({ "background-color" : "#bbbbee" }, 200);
      post.animate({ "background-color" : "#ffffff" }, 200);
    }

    var hiddenPostClickHandler = function(e)
    {
        var i = $(this).index() - 1;
        var that = this;
        $(this).slideToggle(200, function(){

          while (i >= 0)
          {
            var child = $(that).parent().children().eq(i);
            if (!child.is(":visible"))
              child.slideToggle(200);
            i--;
          }

          $(this).remove();
        }); 
        e.preventDefault();
    }

    var FocusOnPost = function(id1, id2) // id1 refers to see id2
    {
      var post1 = $(".wrapper:regex(id,^Post" + id1 + "$)");
      var post2 = $(".wrapper:regex(id,^Post" + id2 + "$)");
      var idMin = Math.min(id1, id2);
      var idMax = Math.max(id1, id2);
      var minPost = post1;
      var maxPost = post2;
      if (idMin == id2)
      {
        minPost = post2;
        maxPost = post1;
      }
      var hiddenCount = 0
      $(".wrapper").each(function(){
        var pat = new RegExp("^Post(\\d+)$");
        var id = parseInt(pat.exec($(this).attr("id"))[1]);
        if (idMin < id && id < idMax)
          if ($(this).is(":visible"))
          {
            $(this).slideToggle(200, function(){
              if (hiddenCount == 0)
              {
                window.location.href="/#" + id2;
              }                
            });
            hiddenCount++;
          }
      });
      if (hiddenCount > 0)
      {
        var prevPost = $(maxPost).parent().children().eq(maxPost.index() - 1);
        var nextPost = $(maxPost).parent().children().eq(maxPost.index() + 1);
        if (prevPost.attr("class") == "hiddenPosts")
          alert("hpost neiught");
        var hiddenPosts = $("<div unselectable=\"on\" class=\"hiddenPosts\">Show hidden posts(" + hiddenCount + ")</div>")
        hiddenPosts.insertBefore(maxPost);
        hiddenPosts.click(hiddenPostClickHandler);        
      }

      if (!post2.is(":visible"))
        post2.slideToggle(200);
      var offset = 20;
      if (minPost.css("left") != "auto")
        offset += parseInt(minPost.css("left"));
      maxPost.animate({ "left" : offset + "px" }, 50);
      HighlightPost(post2);
    }

    $(document).ready(function(){

      $("a:regex(href,^/#\\d+$)").addClass("postref");

      var postAnswers = {};

      $("a:regex(href,^/#\\d+$)").each(function(index, element){
        var pat1 = new RegExp("^/#(\\d+)$");
        var pat2 = new RegExp("^Post(\\d+)$");
        var id = parseInt(pat1.exec($(this).attr("href"))[1]);
        var parentId = parseInt(pat2.exec($(this).parent().attr("id"))[1]);

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

      $("a.postref:regex(href,^/#\\d+$)").click(function(e){
        var href = $(this).attr("href");
        var pat = new RegExp("^/#(\\d+)$");
        var id = pat.exec(href)[1];
        var post = $(":regex(id,^Post" + id + "$)");
        var pat2 = new RegExp("^Post(\\d+)$");
        var parentId = pat2.exec($(this).parent().attr("id"))[1];        
        post.clearQueue();
        FocusOnPost(parseInt(parentId), parseInt(id));
        e.stopPropagation();
        e.preventDefault();        
      });

      $("a.answerref").click(function(e){
        var href = $(this).attr("href");
        var pat = new RegExp("^/#(\\d+)$");
        var id = pat.exec(href)[1];
        var post = $(":regex(id,^Post" + id + "$)");
        post.clearQueue();
        var pat2 = new RegExp("^Post(\\d+)$");
        var parentId = pat2.exec($(this).parent().attr("id"))[1];        
        FocusOnPost(parseInt(parentId), parseInt(id));
        e.preventDefault();
        e.stopPropagation();
      });

      $(".wrapper").click(function(){
        return;
        var pat2 = new RegExp("^Post(\\d+)$");
        var id = parseInt(pat2.exec($(this).attr("id"))[1]);

        if(!postAnswers[id])
          return;

        var that = this;
        var postAnswerIds = [];
        for (var k in postAnswers[id])
          postAnswerIds.push(k);
        postAnswerIds.sort(function (a, b){
          return (b - a);
        });
        for (var i = 0; i < postAnswerIds.length; i++)
        {
          FocusOnPost(id, postAnswerIds[ i ]);
        }

        /*
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
              if ($(this).is(":visible"))
                $(this).slideToggle(200);
            }
          }
          else if ( this != that )
          {
            var offset = 20;
            if ($(that).css("left") != "auto")
              offset += parseInt($(that).css("left"));
            if (!$(this).is(":visible"))
              $(this).slideToggle(200);//.hide();
            $(this).clearQueue();
            $(this).animate({ "left" : offset + "px" }, 50);
            HighlightPost($(this));
          }
        });
        */
      });

      $("#leftSidebar").click(function(){
        $(".wrapper").each(function(){
          if (!$(this).is(":visible"))
            $(this).slideToggle(200);//.hide();          
          //$(this).show();
          $(this).animate({ "left" : "0px" }, 50);
        });
      });

      $("a.PostAnchor").click(function(){
        $("textarea[name=body]").append(">>" + $(this).html() + " ");
        window.location.href='/#footer';
      });

    });
  </script>


</head>

<body>

  <div id="leftSidebar">
  </div>
  <div id="content">
    % for item in pages:
    <div class="wrapper" id="Post${item.id}">
      <div class="postheader">
          <a class="PostAnchor" name="${item.id}">${item.id}</a>
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