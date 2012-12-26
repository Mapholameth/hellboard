var UTCtoLocalTime = function(utcTime)
{
  // var date = new Date("December 17, 1995 03:24:00");
  // date.toLocaleString()
  // offset = new Date()
  // offset.setMinutes(offset.getTimezoneOffset)
  // date = date - offset
  return utcTime//date//Date(utcTime)
}

var HighlightPost = function(post)
{
  post.animate({ "background-color" : "#ffffff" }, 10);
  post.animate({ "background-color" : "#bbbbee" }, 200);
  post.animate({ "background-color" : "#ffffff" }, 200);
}

var hiddenPostClickHandler = function(e)
{
  var minId = parseInt($(this).attr("data-min-id"));
  var maxId = parseInt($(this).attr("data-max-id"));
  var i = $(this).index() - 1;
  var that = this;
  $(this).slideToggle(200, function(){
    for (var i = minId + 1; i < maxId; i++) {
      //var child = $(that).parent().children().eq(i);
      var child = $('.post[data-id=' + i + ']')
      if (child.length != 0)
        if (!child.is(":visible"))
          child.slideToggle(200);
    };

    $(this).remove();
  }); 
  e.preventDefault();
}

var FocusOnPost = function(id1, id2) // id1 refers to see id2
{
  var post1 = $(".post#post-" + id1);
  var post2 = $(".post#post-" + id2);

  if (post1.length == 0 || post2.length == 0)
    return

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

  $(".post").each(function(){
    var id = parseInt($(this).attr("data-id"));
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
    var alreadyHidden = 0
    $(".posts-hidden").each(function(){
      console.log($(this));
      var minId = parseInt($(this).attr("data-min-id"));
      var maxId = parseInt($(this).attr("data-max-id"));
      
      if (!(maxId < idMin || minId > idMax))
      {            
        alreadyHidden += parseInt($(this).attr("data-hidden-count"));
        $(this).slideToggle(200, function(){
          $(this).remove();
        });
      }
    });
    hiddenCount += alreadyHidden;

    var hiddenPosts = $('<div unselectable="on" class="posts-hidden" data-min-id="'
                        + idMin
                        + '" data-max-id="'
                        + idMax
                        + '" data-hidden-count="'
                        + hiddenCount
                        + '">'
                        + 'Show hidden posts('
                        + hiddenCount
                        + ')</div>')
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

  $("a.post-link").addClass("up-link");

  var postDownLinks = {};

  $("a.up-link").each(function(index, element){
    var targetId = parseInt($(this).attr("data-target-id"))
    var parentId = parseInt($(this).attr("data-parent-id"))

    if ( postDownLinks[targetId] == undefined )
      postDownLinks[targetId] = {};

    postDownLinks[targetId][parentId] = true;
  });

  for (var k in postDownLinks)
  {
    var post = $('.post#post-' + k )
    for (var j in postDownLinks[k])
    {
      var link = $('<a href = "/#' + j + '">&gt;&gt;' + j + "</a>")
        .addClass("post-link")
        .addClass("down-link")
        .attr("data-parent-id", k)
        .attr("data-target-id", j)
      post.append(link);
      post.append(" ");
    }
  }

  $("a.post-link").click(function(e){
    var targetId = parseInt($(this).attr("data-target-id"))
    var parentId = parseInt($(this).attr("data-parent-id"))
    FocusOnPost(parentId, targetId);
    e.stopPropagation();
    e.preventDefault();
  });

  $("#left-sidebar").click(function(){
    $(".post").each(function(){
      if (!$(this).is(":visible"))
        $(this).slideToggle(200);
      $(this).animate({ "left" : "0px" }, 50);
    });
  });

  $("a.post-anchor").click(function(e){
    $("textarea[name=body]").append(">>" + $(this).html() + " ");
    $(".postform").insertAfter($(this).parent().parent());
    e.stopPropagation();        
    //window.location.href='/#footer';
  });

  $("#reformat-posts").click(function(e){
    $('<form action="/#footer" method="POST">' + 
      '<input type="hidden" name="reformat-posts" value="">' +
      '</form>').submit();
  });

  $(".delete-post").click(function(e){
    $(this).parent().parent().slideToggle(200, function(){
      $('<form action="/#footer" method="POST">' + 
        '<input type="hidden" name="delete-post" value="' + $(this).attr('data-id') + '">' +
        '</form>').submit();
    })
  })

  $(".post").click(function(e){

  });

  $(".post-datetime").each(function(){
    $(this).text(UTCtoLocalTime($(this).html()))
  })

});
