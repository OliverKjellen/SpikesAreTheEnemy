--[[Everything related to text while playing the main game (text relevant
    to menus etc will be defined in the menu file)]]--

Text = {}

--Initilize the textbox--
function Text:init(x, y)
    self.x = x
    self.y = y
    textbox = {}
    textbox[1] = {width = 330, height = 230, x = self.x, y = self.y}
end

function Text:destroy()
     textbox = nil 
end

function Text:draw()
    if LevelHandler:textboxColor() ~= nil then
        g.setColor(LevelHandler:textboxColor())
    else
        g.setColor(0.5,0.5,0.5, 0.8)
    end
    g.rectangle("fill", textbox[1].x, textbox[1].y, textbox[1].width, textbox[1].height)
    g.setColor(0.5,0.5,0.5, 0.8)
end

function Text:moveDown()
    function move()
        Timer.tween(2, textbox[1], {y = 900}, 'in-out-quad')
    end
    move()
end

function Text:moveTo(x, y)
    local X = x
    local Y = y
    function move()
        Timer.tween(2, textbox[1], {y = Y}, 'in-out-quad')
    end
    move()
    function move2()
        Timer.tween(2, textbox[1], {x = X}, 'in-out-quad')
    end
    move2()
end

function Text:moveAway()
    function move()
        --Timer.tween(0, textbox[1], {y = 2000}, 'in-out-quad')
        textbox[1].y = 2000
    end
    move()
    function move2()
        Timer.tween(2, textbox[1], {x = 100}, 'in-out-quad')
    end
    move2()
end

function Text:reset()
    levelstart = true
    message = ""
end

--Setting up a new message, thanks to the Löve2d forum for some help--
function Text:dialogSetup(msg)
    font = g.newFont(20)
    g.setFont(font)
    message = msg
    elapsed = 0
    letters = 0
    dialog_finished = false
end

function Text:dialogSetup1(msg)
    font = g.newFont(20)
    g.setFont(font)
    message1 = msg
    elapsed1 = 0
    letters1 = 0
    dialog_finished1 = false
end

--Updating the dialog based on delta time, results in the type out effect, 
--thanks to the Löve2d forum for some help--
function Text:dialogUpdate(dt)
    if levelstart == true then
        Timer.script(function(wait)
            wait(2.0)
            levelstart = false
        end)
    end
    if levelstart == false then
        elapsed = elapsed + 0.14
        letters = math.min(math.floor(elapsed), #message)
        if elapsed > #message then
            dialog_finished = true
            SoundHandler:StopSound("typing")
        end
        if dialog_finished ~= true then
            SoundHandler:PlaySound("typing")
        end
        elapsed1 = elapsed1 + 0.14
        letters1 = math.min(math.floor(elapsed1), #message1)
        if elapsed1 > #message1 then
            dialog_finished1 = true
            if dialog_finished == true then
                SoundHandler:StopSound("typing")
            end
        end
        if dialog_finished1 ~= true then
            SoundHandler:PlaySound("typing")
        end
    end
end

function Text:dialogUpdateIntro(dt)
    elapsed = elapsed + 0.09
    letters = math.min(math.floor(elapsed), #message)
    if elapsed > #message then
        dialog_finished = true
        SoundHandler:StopSound("typing")
    end
    if dialog_finished ~= true then
        SoundHandler:PlaySound("typing")
    end
end

function Text:dialogDraw()
    g.setColor(0.0, 0.0, 0.0)
    if message1 ~= nil then
        g.printf(message1:sub(1, letters1), textbox[1].x + 5, textbox[1].y + 200, 300)
    end
    g.printf(message:sub(1, letters), textbox[1].x + 5, textbox[1].y + 5, 300)
end

--Takes input value depending on active level then returns the message relevant to that level--
function Text:storyline(select)
    texts = {
        "5 levels 10 lives! Move using the arrow keys, good luck!",
        "Good! You reached Level_1-2. See those spikey things? Yeah, try not to touch them alright.",
        "Level_1-3 loaded. Wall jumping is certainly possible, just jump again when touching a wall to initialize a walljump.",
        "Level_1-4 loaded. Tip: You can press the down arrow while in mid air to dive",
        "Level_1-5 loaded. Let's make things a bit more difficult shall we?",
        "Level_2-1 loaded. Lives initialized",
        "Level_2-2 loaded. You'll need to dive to avoid those spikes. Do your best, no shame in losing",
        "Level_2-3 loaded. You're doing well so far!",
        "Level_2-4 loaded. One in ten players fail on this level, will you be the one?",
        "Level_2-5 loaded. You made it! Don't fail now and you'll reach level 3.",
        "Level_3-1 loaded. This level even I struggled with when making the game",
        "Level_3-2 loaded. Those spikes leaves no room for error",
        "Level_3-3 loaded. I have to say, we are rather impressed by your progress",
        "Level_3-4 loaded. This level is easy! You can't possibly fail here",
        "Level_3-5 loaded. That's a lot of spikes! Don't step on them",
        "Level_4-1 loaded. Wall jumps are rather simple to perform",
        "Level_4-2 loaded. Do you want to know a secret?",
        "Level_4-3 loaded. Jump and dive, jump and dive",
        "Level_4-4 loaded. How long can you jump?",
        "Level_4-5 loaded. I like wall jumping, do you?",
        "Level_5-1 loaded.",
        "Level_5-2 loaded.",
        "Level_5-3 loaded.",
        "Level_5-4 loaded.",
        "Level_5-5 loaded.",
        "Level_6-1 loaded. GravityChange = active. Press the spacebar to change your local gravity",
        "Level_6-2 loaded. GravityChange = active.",
        "Level_6-3 loaded. GravityChange = active.",
        "Level_6-4 loaded. GravityChange = active.",
        "Level_6-5 loaded. GravityChange = active.",
        "Level_7-1 loaded.",
        "Level_7-2 loaded. GravityChange = active.",
        "Level_7-3 loaded.",
        "Level_7-4 loaded. GravityChange = active.",
        "Level_7-5 loaded.",
        "Level_8-1 loaded. GravityChange = active.",
        "Level_8-2 loaded.",
        "Level_8-3 loaded. GravityChange = active.",
        "Level_8-4 loaded.",
        "You have completed all base levels!! Mucho gracias for playing......Now move on and complete the long levels coming up!",
        "Level_9 loaded. Reach the top, avoid the spikes. Simple enough",
        "Level_10 loaded. Test your balance in this level.",
        "Level_11 loaded. GravityChange = active. Lots of spikes, like usual, avoid them.",
        "Level_12 loaded. This one requires precision, don't get nervous",
        "Level_13 loaded. This one should not be too difficult.",
        "Level_14 loaded. This one requires precision and focus. This is the last level. After this one ther is no more levels. However you will unlock the speed running mode once this level is completed.", 
    }
    for i = 1, #texts, 1 do
        if select == i then
            return texts[i]
        end
    end
end

function Text:storylineSecret(select)
    texts = {
        "Secret Level num 1. Something should be implemented here but it seems like I didn't have the time.",
    }
    for i = 1, #texts, 1 do
        if select == i then
            return texts[i]
        end
    end
end

function Text:intro(select)
    texts = {
        "This is Dave. He can run, jump, dive......and die. Luckily he got 10 lives....more than most of us. Make these 10 lives last, you'll need them. Good luck! Press anywhere on the screen to continue.",
    }
    
    return texts[1]
end
  

