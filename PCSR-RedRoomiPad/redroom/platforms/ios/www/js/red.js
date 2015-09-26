window.addEventListener("load", function load()
{
    var tapTargets = document.getElementsByClassName("tap-target");
    var videos = document.getElementsByTagName("video");
    var audio = document.getElementsByTagName("audio");

    //preload audio
    console.log(audio.length);
    audio[0].preload = "auto";
    audio[0].loop = "true";

    audio[0].play();


    // preload videos
    for(var j = 0; j < videos.length; j++)
    {
        console.log(videos[j].id);

        videos[j].preload = "auto";
    }

    //add event listener for Info button

    var infoButton = document.getElementById("info");

    infoButton.addEventListener("touchstart", function()
    {
        alert("Welcome to Red! Tap on any blinking organ to learn more about the effect of red on us.\r\rWarning: some animations do flash rapidly");

    });

    // add eventlisteners
    for(var i = 0; i < tapTargets.length; i++)
    {
        console.log("target " + i + ": " + tapTargets[i].id);

        // check for tap
        tapTargets[i].addEventListener("touchstart", function partTapped()
        {
            
            console.log(this.id + " tapped!");

            disableTapTargets(tapTargets);

            audio[0].pause();

            playVideo(this.id, tapTargets, audio[0]);

            // enableTapTargets(tapTargets);

        });
    }

}); //end window event listener

function disableTapTargets(tapTargets)
{
    console.log("function disable called");
    for(var i = 0; i < tapTargets.length; i++)
    {
        tapTargets[i].style.display = "none";
    }

    document.getElementById("info").style.display = "none";
}

function enableTapTargets(tapTargets)
{
    for(var i = 0; i < tapTargets.length; i++)
    {
        tapTargets[i].style.display = "inline";
    }

     document.getElementById("info").style.display = "inline";
}

function playVideo(bodyPart, tapTargets, audio)
{
    var videoID = bodyPart + "-video";

    document.getElementById(videoID).style.display = "block";
    document.getElementById(videoID).addEventListener("ended", function()
    {
        console.log("video ended");
        document.getElementById(videoID).style.display = "none"; 
        audio.play();  
        enableTapTargets(tapTargets);       
    });

    document.getElementById(videoID).play();

}