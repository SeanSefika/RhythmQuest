let startTime;

window.startGame = function () {
    document.getElementById("clickBtn").disabled = true;
    document.body.style.backgroundColor = "white";

    let randomTime = Math.random() * 3000 + 1000;

    setTimeout(() => {
        document.body.style.backgroundColor = "green";
        document.getElementById("clickBtn").disabled = false;
        startTime = new Date().getTime();
    }, randomTime);
};

window.stopGame = function () {
    let endTime = new Date().getTime();
    let reactionTime = endTime - startTime;

    let score;

    // More granular scoring system
    // Ideal reaction time is 200-400ms (human perception limit)
    // Score decreases as you get further from ideal
    
    if (reactionTime < 100) {
        score = 50; // Too fast, likely cheating
    } else if (reactionTime < 200) {
        score = 75; // Very fast
    } else if (reactionTime < 300) {
        score = 100; // Excellent
    } else if (reactionTime < 400) {
        score = 95; // Very good
    } else if (reactionTime < 500) {
        score = 85; // Good
    } else if (reactionTime < 600) {
        score = 70; // Average
    } else if (reactionTime < 800) {
        score = 55; // Below average
    } else if (reactionTime < 1000) {
        score = 40; // Slow
    } else {
        score = 25; // Very slow
    }

    alert("Reaction Time: " + reactionTime + " ms\nScore: " + score);

    window.location.href = "/quiz?music_score=" + score;
};