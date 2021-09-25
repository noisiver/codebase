#!/bin/bash
QUOTES=("You can please some of the people all of the time, you can please all of the people some of the time, but you can’t please all of the people all of the time." \
        "I disapprove of what you say, but I will defend to the death your right to say it." \
        "Don't let your friends you made memories with, become the memories." \
        "You can not excel at anything you do not love." \
        "Early is on time, on time is late and late is unacceptable." \
        "The journey of a thousand miles begins with one step." \
        "That which does not kill us makes us stronger." \
        "Fortune favors the bold." \
        "Life is what happens when you’re busy making other plans." \
        "When the going gets tough, the tough get going." \
        "You must be the change you wish to see in the world." \
        "You only live once, but if you do it right, once is enough." \
        "I think, therefore I am." \
        "Tough times never last but tough people do." \
        "Get busy living or get busy dying." \
        "Whether you think you can or you think you can’t, you’re right." \
        "Tis better to have loved and lost than to have never loved at all." \
        "Time is money." \
        "A man is but what he knows." \
        "You miss 100 percent of the shots you never take." \
        "If you’re going through hell, keep going." \
        "Strive not to be a success, but rather to be of value." \
        "I came, I saw, I conquered." \
        "Twenty years from now you will be more disappointed by the things that you didn’t do than by the ones you did do." \
        "Great minds discuss ideas; average minds discuss events; small minds discuss people." \
        "Those who dare to fail miserably can achieve greatly." \
        "The opposite of love is not hate; it’s indifference." \
        "When life gives you lemons, make lemonade." \
        "Never let the fear of striking out keep you from playing the game." \
        "Life is like a box of chocolates. You never know what you’re going to get." \
        "He that falls in love with himself will have no rivals." \
        "Life is ten percent what happens to you and ninety percent how you respond to it." \
        "Practice makes perfect." \
        "Dream big and dare to fail." \
        "A great man is always willing to be little." \
        "That’s one small step for a man, one giant leap for mankind." \
        "Every man is guilty of all the good he did not do." \
        "Knowledge is power." \
        "A successful man is one who can lay a firm foundation with the bricks others have thrown at him." \
        "In three words I can sum up everything I’ve learned about life: It goes on." \
        "If you judge people, you have no time to love them." \
        "The future belongs to those who prepare for it today." \
        "Don’t be afraid to give up the good to go for the great." \
        "Have no fear of perfection, you'll never reach it." \
        "The greatest glory in living lies not in never falling, but in rising every time we fall." \
        "When you reach the end of your rope, tie a knot in it and hang on." \
        "No one can make you feel inferior without your consent." \
        "In the long run, the sharpest weapon of all is a kind and gentle spirit." \
        "Sing like no one’s listening, love like you’ve never been hurt, dance like nobody’s watching, and live like it’s heaven on earth." \
        "It always seems impossible until it’s done." \
        "Do what you can, with what you have, where you are." \
        "People are just as happy as they make up their minds to be." \
        "Every great dream begins with a dreamer. Always remember, you have within you the strength, the patience, and the passion to reach for the stars to change the world." \
        "Success is not final, failure is not fatal: it is the courage to continue that counts." \
        "Remember that the happiest people are not those getting more, but those giving more." \
        "If you want to be happy, be." \
        "The only impossible journey is the one you never begin." \
        "When I dare to be powerful – to use my strength in the service of my vision, then it becomes less and less important whether I am afraid." \
        "I have no special talent. I am only passionately curious." \
        "The only person you are destined to become is the person you decide to be." \
        "May you live all the days of your life." \
        "Hope for the best, but prepare for the worst." \
        "We have nothing to fear but fear itself." \
        "Those who cannot remember the past are condemned to repeat it." \
        "The only thing necessary for the triumph of evil is for good men to do nothing." \
        "Insanity is doing the same thing over and over again and expecting different results." \
        "Life would be tragic if it weren’t funny." \
        "Simplicity is the ultimate sophistication." \
        "It is never too late to be what you might have been." \
        "The power of imagination makes us infinite." \
        "Everything you’ve ever wanted is on the other side of fear." \
        "We design our lives through the power of choices." \
        "Shoot for the moon. Even if you miss, you’ll land among the stars." \
        "Genius is eternal patience." \
        "If you tell the truth, you don’t have to remember anything." \
        "Knowing yourself is the beginning of all wisdom." \
        "We are what we repeatedly do; excellence, then, is not an act but a habit." \
        "Life is not a problem to be solved, but a reality to be experienced." \
        "All that we see and seem is but a dream within a dream." \
        "Love all, trust a few, do wrong to none." \
        "The question isn’t who is going to let me; it’s who is going to stop me." \
        "Yesterday is history, tomorrow is a mystery, today is a gift of God, which is why we call it the present." \
        "What you do speaks so loudly that I cannot hear what you say." \
        "Those who make you believe absurdities can make you commit atrocities." \
        "You can discover more about a person in an hour of play than in a year of conversation." \
        "Change your thoughts, and you change your world." \
        "Once you’ve accepted your flaws, no one can use them against you." \
        "When we strive to become better than we are, everything around us becomes better too." \
        "Our greatest fear should not be of failure… but of succeeding at things in life that don’t really matter." \
        "Challenges are what make life interesting and overcoming them is what makes life meaningful." \
        "You will face many defeats in life, but never let yourself be defeated." \
        "The secret of getting ahead is getting started." \
        "Keep your face to the sunshine and you can never see the shadow." \
        "Always forgive your enemies; nothing annoys them so much." \
        "Power tends to corrupt, and absolute power corrupts absolutely." \
        "Do not go where the path may lead; go instead where there is no path and leave a trail." \
        "Those who cannot remember the past are condemned to repeat it." \
        "Nothing is impossible, the word itself says, ‘I’m possible!’" \
        "Always remember that you are absolutely unique. Just like everyone else." \
        "Don’t count the days, make the days count." \
        "It is better to fail in originality than to succeed in imitation." \
        "A mind is like a parachute. It doesn’t work if it isn’t open." \
        "I’m selfish, impatient and a little insecure. I make mistakes, I am out of control and at times hard to handle. But if you can’t handle me at my worst, then you sure as hell don’t deserve me at my best." \
        "It is our choices, that show what we truly are, far more than our abilities." \
        "A lion doesn’t concern himself with the opinions of the sheep." \
        "Stay hungry, stay foolish." \
        "The way to get started is to quit talking and begin doing." \
        "Originality is nothing but judicious imitation." \
        "A friend is someone who gives you total freedom to be yourself." \
        "I alone cannot change the world, but I can cast a stone across the water to create many ripples." \
        "You’ll never find a rainbow if you’re looking down." \
        "It’s never too late to be who you might have been." \
        "If you aren’t going all the way, why go at all?" \
        "Science is what you know. Philosophy is what you don’t know." \
        "The successful warrior is the average man, with laser-like focus." \
        "You know you’re in love when you can’t fall asleep because reality is finally better than your dreams." \
        "Ability is of little account without opportunity." \
        "If you don't stand for something you will fall for anything." \
        "In order to write about life first you must live it." \
        "The big lesson in life, baby, is never be scared of anyone or anything." \
        "We don’t stop playing because we grow old; we grow old because we stop playing." \
        "If I have seen further than others, it is by standing upon the shoulders of giants." \
        "Many of life’s failures are people who did not realize how close they were to success when they gave up." \
        "When we strive to become better than we are, everything around us becomes better too." \
        "Life has no limitations, except the ones you make." \
        "Holding onto anger is like drinking poison and expecting the other person to die." \
        "The further a society drifts from the truth, the more it will hate those that speak it." \
        "All our dreams can come true if we have the courage to pursue them." \
        "You are never too old to set another goal or to dream a new dream." \
        "Life itself is the most wonderful fairy tale." \
        "It isn’t where you came from. It’s where you’re going that counts." \
        "Turn your wounds into wisdom." \
        "The price of greatness is responsibility." \
        "Knowledge makes a man unfit to be a slave." \
        "Happiness is a direction, not a place." \
        "Great geniuses have the shortest biographies." \
        "Try to be a rainbow in someone else’s cloud." \
        "In the middle of difficulty lies opportunity." \
        "The best way out is always through." \
        "Happiness depends upon ourselves." \
        "Be yourself; everyone else is already taken." \
        "I am, therefore I think." \
        "Whatever you do, do with all your might." \
        "All limitations are self-imposed." \
        "No pressure, no diamonds." \
        "Time you enjoy wasting is not wasted time." \
        "Keep your friends close, but your enemies closer." \
        "The time is always right to do what is right." \
        "Well done is better than well said." \
        "There is nothing impossible to him who will try." \
        "The pen is mightier than the sword." \
        "This above all: to thine own self be true." \
        "Actions speak louder than words." \
        "The purpose of our lives is to be happy." \
        "All that we are is the result of what we have thought." \
        "Arguing with a fool proves there are two." \
        "A penny saved is a penny earned." \
        "Necessity is the mother of invention." \
        "All’s well that ends well." \
        "The end doesn’t justify the means." \
        "Look before you leap." \
        "All's fair in love and war." \
        "Two heads are better than one." \
        "Leave no stone unturned." \
        "The more things change, the more they remain the same." \
        "Leave nothing for tomorrow which can be done today." \
        "There’s a sucker born every minute." \
        "Everyone will be famous for 15 minutes." \
        "A picture is worth a thousand words." \
        "An ounce of action is worth a ton of theory." \
        "A fool and his money are soon parted." \
        "He who angers you conquers you." \
        "A mind is a terrible thing to waste." \
        "Two wrongs don’t make a right." \
        "Don't put the cart before the horse." \
        "You can’t make an omelet without breaking a few eggs." \
        "Beggars can’t be choosers." \
        "If it ain’t broke, don’t fix it." \
        "All good things must come to an end." \
        "Beauty is in the eye of the beholder." \
        "Familiarity breeds contempt." \
        "The early bird catches the worm." \
        "All things come to those who wait." \
        "A chain is only as strong as its weakest link." \
        "Honesty is the best policy." \
        "Don’t count your chickens before they hatch." \
        "Even a stopped clock is right twice a day." \
        "Great minds think alike." \
)

[[ -f $CORE_DIRECTORY/bin/auth.sh && -f $CORE_DIRECTORY/bin/authserver ]] && ENABLE_AUTHSERVER=1 || ENABLE_AUTHSERVER=0
[[ -f $CORE_DIRECTORY/bin/world.sh && -f $CORE_DIRECTORY/bin/worldserver ]] && ENABLE_WORLDSERVER=1 || ENABLE_WORLDSERVER=0
[ ! -f $CORE_DIRECTORY/bin/start.sh ] && ENABLE_AUTHSERVER=1 ENABLE_WORLDSERVER=1

function main_menu
{
    clear
    printf "${COLOR_PURPLE}AzerothCore${COLOR_END}\n"
    printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the source code${COLOR_END}\n"
    printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Manage the databases${COLOR_END}\n"
    printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Manage the configuration options${COLOR_END}\n"
    if [[ -f $CORE_DIRECTORY/bin/start.sh && -f $CORE_DIRECTORY/bin/stop.sh ]] && [[ -f $CORE_DIRECTORY/bin/auth.sh || -f $CORE_DIRECTORY/bin/world.sh ]] && [[ -f $CORE_DIRECTORY/bin/authserver && -f $CORE_DIRECTORY/bin/worldserver ]]; then
        printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Manage the compiled binaries${COLOR_END}\n"
    fi
    printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Exit${COLOR_END}\n"
    printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
    read -n 1 s

    case $s in
        1) source_menu;;
        2) database_menu;;
        3) configuration_menu;;
        4) binary_menu;;
        0) exit_menu;;
        *) main_menu;;
    esac
}

function source_menu
{
    clear
    printf "${COLOR_PURPLE}Manage the cource code${COLOR_END}\n"
    printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the available modules${COLOR_END}\n"
    printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Download the latest version of the repository${COLOR_END}\n"
    printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Compile the source code into binaries${COLOR_END}\n"
    printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
    printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
    read -n 1 s

    case $s in
        1) source_module_menu;;
        2) stop_process; clone_source; source_menu;;
        3) source_compile_menu;;
        0) main_menu;;
        *) source_menu;;
    esac
}

function source_module_menu
{
    clear
    printf "${COLOR_PURPLE}Manage the available modules${COLOR_END}\n"
    printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Eluna LUA Engine: ${COLOR_END}"
    [ $MODULE_ELUNA_ENABLED == "true" ] && printf "${COLOR_GREEN}Enabled${COLOR_END}\n" || printf "${COLOR_RED}Disabled${COLOR_END}\n"
    printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
    printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
    read -n 1 s

    case $s in
        1) if [ $MODULE_ELUNA_ENABLED == "true" ]; then MODULE_ELUNA_ENABLED="false"; else MODULE_ELUNA_ENABLED="true"; fi; generate_settings; source_module_menu;;
        0) source_menu;;
        *) source_module_menu;;
    esac
}

function source_compile_menu
{
    clear
    printf "${COLOR_PURPLE}Compile the source code into binaries${COLOR_END}\n"
    printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Authserver: ${COLOR_END}"
    [ $ENABLE_AUTHSERVER == 1 ] && printf "${COLOR_GREEN}Enabled${COLOR_END}\n" || printf "${COLOR_RED}Disabled${COLOR_END}\n"
    printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Worldserver: ${COLOR_END}"
    [ $ENABLE_WORLDSERVER == 1 ] && printf "${COLOR_GREEN}Enabled${COLOR_END}\n" || printf "${COLOR_RED}Disabled${COLOR_END}\n"
    printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Compile with these settings${COLOR_END}\n"
    printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
    printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
    read -n 1 s

    case $s in
        1) [ $ENABLE_AUTHSERVER == 0 ] && ENABLE_AUTHSERVER=1 || ENABLE_AUTHSERVER=0; source_compile_menu;;
        2) [ $ENABLE_WORLDSERVER == 0 ] && ENABLE_WORLDSERVER=1 || ENABLE_WORLDSERVER=0; source_compile_menu;;
        3) if [[ $ENABLE_AUTHSERVER == 1 && $ENABLE_WORLDSERVER == 1 ]]; then compile_source 0; elif [[ $ENABLE_AUTHSERVER == 1 && $ENABLE_WORLDSERVER == 0 ]]; then compile_source 1; elif [[ $ENABLE_AUTHSERVER == 0 && $ENABLE_WORLDSERVER == 1 ]]; then compile_source 2; fi; source_compile_menu;;
        0) source_menu;;
        *) source_compile_menu;;
    esac
}

function database_menu
{
    clear
}

function configuration_menu
{
    clear
}

function binary_menu
{
    clear
}

function exit_menu
{
    clear
    printf "${COLOR_PURPLE}Have a amazingly wonderful day!${COLOR_END}\n"
    printf "${COLOR_ORANGE}${QUOTES[$(( RANDOM % ${#QUOTES[@]} ))]}${COLOR_END}\n"
}
