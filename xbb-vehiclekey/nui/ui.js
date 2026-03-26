sound = (data) => {
    var soundEff = new Audio(`./sound/${data.type}.ogg`);
    soundEff.volume = 0.3;
    soundEff.play();
}

window.addEventListener("message" , function( GET ) {
    if(GET.data != null){
        let data = GET.data.data;
        let eventName = GET.data.eventName
        switch(eventName) {
            case 'playsound':
                sound(data)
                break;
        }
    }
})