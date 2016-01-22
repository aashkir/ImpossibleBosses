var COLOUR_NORMAL = "#FFFFFF";
var COLOUR_WARNING = "#DF161F";
var TIMER_INTERVAL = 0.05;
var startTime = -1;
var timerWarning = -1;
var timerDuration = 0;
var timerMode = 0; // Countdown = 0, Countup = 1
var timerMessage = "Remaining";
var timerEnd = false; // When true, hide on timer end
var timerPosition = 0; 
var timerPaused = false;
var timerSound = false;
var timer = null;
//var timerWarning = -1; // Second to start warning at from end (-1 Disabled)
var timerLast = 0;

var timer = $( "#TimerBox" );

function UpdateTimer() {
	if (timerPaused)
		startTime += 0.05;
	var timerTextRemain = $( "#health_bar" );
	var time = Game.GetGameTime() - startTime;
	var remaining = 3;


	if (remaining > 2) {
			timerTextRemain.text = FormatTime(time);
	}

	if (Entities.IsAlive( bossid ))
		$.Schedule(TIMER_INTERVAL, function(){UpdateTimer();});
	else
		if (!Entities.IsAlive( bossid ))
			$.Schedule(0.3, function(){FadeOut();});

}

function FadeIn() {
	timer.AddClass("FadeIn");

}

function FadeOut() {
	timer.RemoveClass("FadeIn");
}

function DisplayTimer( table ) {
	timerMessage = table.msg || "Remaining";
	timerDuration = table.duration;
	timerMode = table.mode;
	timerEnd = table.endfade;
	timerPosition = table.position;
	bossid = table.warning;
	timerPaused = table.paused;
	timerSound = table.sound;
	startTime = Game.GetGameTime();
	var timerTextMsg = $( "#TimerMsg" );
	timerTextMsg.text = $.Localize(timerMessage);
	UpdateTimer();
	FadeIn();
}

function PauseTimer( bool ) {
	timerPaused = bool.pause;
}

// "Health Bar"
function FormatTime( data, table ) {
	var panel = $('#TimerMsg')
	var panelmana = $('#ManaMsg')

	var	heroHealthPercentage = Entities.GetHealthPercent(bossid)
	var	heroMana = Entities.GetMana(bossid)
	var manaPct = (heroMana / Entities.GetMaxMana( bossid )) * 100
	var fill_bar = panel.FindChildrenWithClassTraverse("BaseHud")[0]
	panelmana.style.width = manaPct.toString() + "%"
	panel.style.width = heroHealthPercentage.toString() + "%"
	return heroHealthPercentage
}

(function () {
  GameEvents.Subscribe( "display_health", DisplayTimer );
  GameEvents.Subscribe( "pause_health", PauseTimer );
})();