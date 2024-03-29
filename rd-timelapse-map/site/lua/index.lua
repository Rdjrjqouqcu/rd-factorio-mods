return {

    html = [[
<!DOCTYPE html>
<html>
    <head>
        <title>FactorioMaps</title>
        <link href="lib/favicon.ico" rel="icon" type="image/x-icon">
        <meta name="og:image" content="Images/thumbnail.png"/>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
        
        <link rel="stylesheet" href="index.css"/>

        <link rel="stylesheet" href="lib/leaflet.css"/>
        <link rel="stylesheet" href="lib/jquery-ui.css">
        <link rel="stylesheet" href="lib/Control.Opacity.css"/>

        <script src="lib/leaflet-src.min.js"></script>
        <script src="lib/jquery.min.js"></script>
        <script src="lib/jquery-ui.min.js"></script>
        <script src="lib/Control.Opacity.js"></script>

        <script src="mapInfo.js"></script>
    </head>

    <body>
        <div id="map" style="background: #1B2D33;"></div>

        <script src="index.js"></script>
    </body>
</html>
]],

    css = [[
html {
    height: 100%
}

body {
    height: 100%;
    margin: 0px;
    padding: 0px
}

#map {
    height: 100%;
    z-index: 0;
    background-color: rgb(27, 44, 51) !important;
}

#gmnoprint {
    width: auto;
}

/* DOWN BUTTON CSS */
#downBtn {
    position: fixed;
    /* Fixed/sticky position */
    bottom: 0px;
    /* Place the button at the bottom of the page */
    right: 50%;
    transform: translate(50%, 0);
    z-index: 99;
    /* Make sure it does not overlap */
    border: none;
    /* Remove borders */
    outline: none;
    /* Remove outline */
    background-color: chocolate;
    /* Set a background color */
    color: white;
    /* Text color */
    cursor: pointer;
    /* Add a mouse pointer on hover */
    padding: 5px;
    /* Some padding */
    border-radius: 7px;
    /* Rounded corners */
    font-size: 18px;
    /* Increase font size */
}

#downBtn:hover {
    background-color: #555;
    /* Add a dark-grey background on hover */
}

/* FANCY DOWNLOAD CSS */
#modal {
    display: none;
    position: absolute;
    top: 150px;
    bottom: 30px;
    background-color: rgb(27, 45, 51);
    padding: 20px;
    z-index: 100;
    width: 400px;
    right: 50%;
    margin-right: -200px;
    border: none;
    border-radius: 5px;
    color: #C6FFFD;
}

#modal.open {
    display: block;
}

#modal ul li {
    list-style-type: none;
    margin-bottom: 5px;
}

#modal .close {
    cursor: pointer;
    float: right;
    margin-top: -20px;
}

#modal .title {
    font-size: 2em;
    text-align: center;
    margin-bottom: 15px;
}

#modal .mapLayerLink {
    float: right;
    padding: 0px 25px;
    background-color: chocolate;
    color: #CFFFFD;
    border-radius: 8px;
    line-height: 35px;
}

#modal .mapLayerLink.disabled {
    background-color: grey;
    cursor: not-allowed;
}

#modal .mapLayerLink:hover {
    background-color: #555;
}

hr.clear {
    clear: both;
    float: none;
    border: 0;
    width: 0;
    height: 0;
    padding: 0;
    margin: 0;
}

#modal .body {
    overflow-y: auto;
    max-height: 92%;
}

/* END FANCY DOWNLOAD CSS */
#nextBtn {
    position: fixed; /* Fixed/sticky position */
    top: 50%; /* Place the button at the bottom of the page */
    right: -38px; /* Place the button 30px from the right */
    z-index: 99; /* Make sure it does not overlap */
    border: none; /* Remove borders */
    outline: none; /* Remove outline */
    background-color: chocolate; /* Set a background color */
    color: white; /* Text color */
    cursor: pointer; /* Add a mouse pointer on hover */
    padding: 6px; /* Some padding */
    border-radius: 6px; /* Rounded corners */
    font-size: 18px; /* Increase font size */
    transform: rotate(90deg);
}

#nextBtn:hover {
    background-color: #555; /* Add a dark-grey background on hover */
}
#prevBtn {
    position: fixed; /* Fixed/sticky position */
    top: 50%; /* Place the button at the bottom of the page */
    left: -35px; /* Place the button 30px from the right */
    z-index: 99; /* Make sure it does not overlap */
    border: none; /* Remove borders */
    outline: none; /* Remove outline */
    background-color: chocolate; /* Set a background color */
    color: white; /* Text color */
    cursor: pointer; /* Add a mouse pointer on hover */
    padding: 6px; /* Some padding */
    border-radius: 6px; /* Rounded corners */
    font-size: 18px; /* Increase font size */
    transform: rotate(-90deg);
}

#prevBtn:hover {
    background-color: #555; /* Add a dark-grey background on hover */
}

.leaflet-overlay-pane > img,
img.leaflet-tile.leaflet-tile-loaded {
    image-rendering: pixelated;
    image-rendering: crisp-edges;
}


map-marker {
    width: 32px;
    height: 32px;
    margin-left: -16px;
    margin-top: -16px;
    display: block;
    cursor: grab;
}
map-marker span {
    color: white;
    font-size: 1em;
    margin: 0 -32px;
    text-align: center;
    display: block;
    width: 96px;
}
map-marker span img {
    height: 2em;
    width: 2em;
    margin: 0 .5em -.75em .5em;
}

map-marker.map-marker-default:before {
    content: "";
    display: inline-block;
    background-color: red;
    width: 19px;
    height: 19px;
    border: solid 6.5px #0F0;
    border-radius: 16px;
}

map-link {
    display: block;
    box-shadow: inset 0 0 6px 3px #0099ff;
    will-change: width, height, margin-left, margin-top;
    transition: width		0.25s cubic-bezier(0,0,0.25,1),
                height		0.25s cubic-bezier(0,0,0.25,1),
                margin-left	0.25s cubic-bezier(0,0,0.25,1),
                margin-top	0.25s cubic-bezier(0,0,0.25,1);
    width:	calc(1px/var(--devicepixelratio)*var(--scale)*var(--y));
    height:	calc(1px/var(--devicepixelratio)*var(--scale)*var(--x));
    margin-left: calc(-.5px/var(--devicepixelratio)*var(--scale)*var(--y));
    margin-top:  calc(-.5px/var(--devicepixelratio)*var(--scale)*var(--x));
    cursor: pointer;
}

map-link::before {
    content: '';
    position: absolute;
    width: 200%;
    height: 200%;
    box-shadow: inset 0 0 10px 5px #0099ff;
    opacity: 0;
    transition: opacity 0.3s ease-in-out;
}
map-link:hover::before {
    opacity: 1;
}
]],

}