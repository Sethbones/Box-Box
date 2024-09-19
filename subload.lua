--in hindsight maybe not the best idea but it felt good writing it
function Fader(FadeState, active, r,g,b,a, pausetime, waittime, type, sceneswitch, autostate,reverse) --FadeState is for debugging, leave at 0
--active is for it to it to be set as active or wait for manual input
--r,g,b,a(default: 255,255,255,255) indicate the color and starting alpha of the transition
--pausetime (default: 1) is the pausetime untill action of sort is taken
--waittime (default: 1) is how long to wait after the transition is finished
--type (default: "basic") controls the type:currently there's only one type but there's goping to be a couple more as time goes on
    --types:
        --basic, the default turns the screen black and then turns it white
        --side to side 
        --side to side sharp
        --up and down
        --up and down sharp
--sceneswitch (default: false) controls if it changes a variable on use or not
--autostate (default: true) controls if it switches states automatically or not, note that, setting it to false makes it so you have to call fader.fadestate manually
--reverse (default: false) plays the effect backwards from state 2 to state 0 and then state 3
    FadeState = 0
    active = false
    r,g,b,a = 0,0,0,255
    pausetime = 1
    waittime = 1
    type = "basic"
    sceneswitch = false
    autostate = true
    reverse = false

    Fader = {}
    Fader.red = r
    Fader.green = g
    Fader.blue = b
    Fader.alpha = a
    Fader.Type = type
    Fader.switchscenes = sceneswitch
    Fader.automovestates = autostate
    Fader.ReverseTransition = reverse
    Fader.transitionState = FadeState -- 0 - fade in, 1 - pause, 2 - fade out, 3 - wait
    Fader.transitionactive = active
    Fader.transitionpausetime = pausetime
    Fader.timetilnextscene = waittime
end

function Fader_draw()
    love.graphics.setColor(love.math.colorFromBytes(Fader.red,Fader.green,Fader.blue,Fader.alpha))
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    if Fader.transitionactive == true then
        if Fader.transitionState == 0 then --alpha decreases
            if Fader.alpha > 0 then
                Fader.alpha = Fader.alpha - 1
                print("going down")
            else
                Fader.alpha = 0
                Fader.transitionState = 1
            end
        end
        if Fader.transitionState == 1 then -- wait before before moving states
            print("in state 1")
            if Fader.transitionpausetime > 0 then
                Fader.transitionpausetime = Fader.transitionpausetime - 1 * love.timer.getDelta()
            else
                Fader.transitionpausetime = 0
                Fader.transitionState = 2
            end
        end
        if Fader.transitionState == 2 then --alpha increases
            if Fader.alpha < 255 then
                Fader.alpha = Fader.alpha + 1
            else
                Fader.alpha = 255
                Fader.transitionState = 3
            end
        end
        if Fader.transitionState == 3 then --wait before doing anything afterwards
            if Fader.timetilnextscene > 0 then
                print("waiting")
                Fader.timetilnextscene = Fader.timetilnextscene - 1 * love.timer.getDelta()
            else
                Fader.timetilnextscene = 0
                Fader.transitionactive = false
            end
        end
    else
        Fader.alpha = 0
        --call action ()
    end
end
function StartFader()
    Fader.transitionactive = true
    Fader.transitionState = 0
    Fader.alpha = 255
    Fader.transitionpausetime = 1
end

function Menustatecheck() --check each menu state and act accordingly
        if menustate == 0 then
            StartFader()
            if menustate == 0 and Fader.transitionactive == false then
                menustate = 3
            end
        elseif menustate == 1 then
            menustate = 3
        elseif menustate == 2 then
            menustate = 3
        elseif menustate == 3 then
    end
end

function SceneSwap()
    if menustate == 0 then
        menustate = 3
    end
end


--i forgot what this was here for
function clearwindow()

end

function BoxDraw(x, y, Ar,Ag,Ab, Br,Bg,Bb, Cr,Cg,Cb, Dr,Dg,Db, Er,Eg,Eb)
    love.graphics.setColor(love.math.colorFromBytes(Ar, Ag, Ab))
    love.graphics.draw(BoxResource, BoxAsset.BoxSpriteA, x, y)
    love.graphics.setColor(love.math.colorFromBytes(Br, Bg, Bb))
    love.graphics.draw(BoxResource, BoxAsset.BoxSpriteB, x, y)
    love.graphics.setColor(love.math.colorFromBytes(Cr, Cg, Cb))
    love.graphics.draw(BoxResource, BoxAsset.BoxSpriteC, x, y)
    love.graphics.setColor(love.math.colorFromBytes(Dr, Dg, Db))
    love.graphics.draw(BoxResource, BoxAsset.BoxSpriteD, x, y)
    love.graphics.setColor(love.math.colorFromBytes(Er, Eg, Eb))
    love.graphics.draw(BoxResource, BoxAsset.BoxSpriteE, x, y)
end
--this is the file where every sub function is called to
--i.e a custom mouse swipe's function would be here