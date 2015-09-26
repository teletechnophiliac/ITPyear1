var storiesDB = useDatabase("stories");

serveFiles("itpfiction");

route('/addstory', addStory);
route('/viewstories', getStories);
route('/', addStory);
route('/search', searchStories);
route('/story', readStory);
//route('/tag', getTag);

function getStories(request) 
{
  storiesDB.getAll(gotStories);
  
  function gotStories(stories) 
  {
    var renderData = {theStories: stories};
    request.render("storiestemplate.html",renderData);
  }
  
}

/*
function getTag(request) 
{
  var arrTags = request.params.tagsraw.split(', ');
  
  storiesDB.find(arrTags, findTag)
  
  function findTag(theStories)
  {
    var storiesWithTag = [];
    var storyCount = 0;
    var tagIndex = 0;
   for (i = 0; i < theStories.length; i++) 
		  {
		    for(t = 0; t < theStories[i].tags.length; t++)
		    {
  		    if(theStories[i].tags[t] === arrTags[tagIndex]) 
  		    {
  		  	  storiesWtihTag[storyCount].titles = theStories[i].titles
  		  	  storyCount ++;
  		  	  
  		  	  //stuck on how to check for multiple tags, three nested loops?!
  		    }
		    }
		  }
  }
}
*/

function addStory(request) 
{

  console.log("add story");
  
  var arrTags = request.fields.tagsraw.split(', ');
  
  for(var t = 0; t < arrTags.length; t++)
  {
    console.log(arrTags[t]);
  }
  
  var newStory = 
  {
    title: request.fields.titletext,
    author: request.fields.author,
    story: request.fields.story,
    tagsArray: arrTags
  };

  storiesDB.add(newStory);
  request.redirect("/viewstories");
}

function readStory(request) 
{
  console.log('readstory');
  
  var id = request.params._id;
  
  storiesDB.getOne(id, readingStory);
  
  function readingStory(selectedStory)
  {
    console.log("readingStory");
    
    renderData = {theStory: selectedStory};
    request.render("storytemplate.html", renderData);
  }
}

function searchStories(request)
{
  var title = request.params.titletext;
  var author = request.params.author;
  
  if(title === "" & author === "")
  {
    request.respond("No search parameters entered.");
  }
  else if (title===""||title===null)
  {
    storiesDB.getAll(searchAuthor);    
  }
  else if(author===""||author===null)
  {
    storiesDB.getAll(searchTitle);
  }
  else if(title !== null & author !== null)
  {
    storiesDB.getAll(searchForAStory);
  }
  else
    request.respond("search didn't work");
    
  var response; 
  
  function searchAuthor(theStories) 
  	{
  	  var responseJSON = [];
		  response = "The author " + author + " wrote: \n";
	  	for (i = 0; i < theStories.length; i++) 
		  {
		    if(theStories[i].author === author) {
		  	  response += theStories[i].titles + "\n";
		  	  responseJSON[0].titles = theStories[i].titles
		    }
		  }
		  request.respond(response);
  	}
  	
  	function searchTitle(theStories) 
  	{
		  response = "The story " + title + " was written by: \n";
	  	for (i = 0; i < theStories.length; i++) 
		  {
		    if(theStories[i].title === title)
		  	  response += theStories[i].author + "\n";
		  }
		  request.respond(response);
  	}
  	
  	function searchForAStory(theStories) 
  	{
  	  response = "";
	  	for (i = 0; i < theStories.length; i++) 
		  {
		    if(theStories[i].title === title & theStories[i].author === author)
		  	  response = "There is a story called " + title + " by " + author + ".";
		  }
		  if(response === "")
		    response = "No story exists with that title and author.";
		  request.respond(response);
  	}
}


