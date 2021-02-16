DYNEScoreboard = {}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                DYNEScoreboard.Open(event.data);
                break;
            case "close":
                DYNEScoreboard.Close();
                break;
            case "updatePlayTime":
                DYNEScoreboard.UpdateTime(event.data);
                break;
        }
    })
});

DYNEScoreboard.Open = function(data) {
    $(".scoreboard-block").fadeIn(150);
    $("#total-players").html("<p>"+data.players+"/"+data.maxPlayers+"</p>");
    $("#player-name").html("<p>"+data.playerName+"</p>");
    $("#player-id").html("<p>"+data.playerId+"</p>");
    $("#play-time").html("<p>"+data.playTime+"</p>");
    $("#jobs").html("<p>🚑: "+data.ambulance+"&nbsp; | 🔧: "+data.mechanic+"&nbsp; | 🚕: "+data.taxi+"</p>");

    $.each(data.requiredCops, function(i, category){
        var beam = $(".scoreboard-info").find('[data-type="'+i+'"]');
        var status = $(beam).find(".info-beam-status");


        if (category.busy) {
            $(status).html('<i class="fas fa-clock"></i>');
        } else if (data.currentCops >= category.minimum) {
            $(status).html('<i class="fas fa-check"></i>');
        } else {
            $(status).html('<i class="fas fa-times"></i>');
        }
    });
}

DYNEScoreboard.Close = function() {
    $(".scoreboard-block").fadeOut(150);
}

DYNEScoreboard.UpdateTime = function(data) {
    $("#play-time").html("<p>"+data.playTime+"</p>");
}