import 'package:flutter/cupertino.dart';
import 'dart:math';
import '../theme/visual_effects_config.dart';
import '../widgets/visual_effects_widgets.dart';

class AdviceScreen extends StatefulWidget {
  const AdviceScreen({super.key});

  @override
  State<AdviceScreen> createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  String _currentAdvice = '';
  String _currentCategory = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> _adviceList = [
    // Motivation (20)
    {
      'category': 'Motivation',
      'advice':
          'The best time to plant a tree was 20 years ago. The second best time is now.',
    },
    {
      'category': 'Motivation',
      'advice': 'Don\'t wait for opportunity. Create it.',
    },
    {
      'category': 'Motivation',
      'advice': 'Your limitation—it\'s only your imagination.',
    },
    {
      'category': 'Motivation',
      'advice': 'Great things never come from comfort zones.',
    },
    {'category': 'Motivation', 'advice': 'Dream it. Wish it. Do it.'},
    {
      'category': 'Motivation',
      'advice':
          'Success doesn\'t just find you. You have to go out and get it.',
    },
    {
      'category': 'Motivation',
      'advice':
          'The harder you work for something, the greater you\'ll feel when you achieve it.',
    },
    {'category': 'Motivation', 'advice': 'Dream bigger. Do bigger.'},
    {
      'category': 'Motivation',
      'advice': 'Don\'t stop when you\'re tired. Stop when you\'re done.',
    },
    {
      'category': 'Motivation',
      'advice': 'Wake up with determination. Go to bed with satisfaction.',
    },
    {
      'category': 'Motivation',
      'advice': 'Do something today that your future self will thank you for.',
    },
    {'category': 'Motivation', 'advice': 'Little things make big days.'},
    {
      'category': 'Motivation',
      'advice': 'It\'s going to be hard, but hard does not mean impossible.',
    },
    {
      'category': 'Motivation',
      'advice':
          'Don\'t wait for the perfect moment. Take the moment and make it perfect.',
    },
    {
      'category': 'Motivation',
      'advice':
          'Sometimes we\'re tested not to show our weaknesses, but to discover our strengths.',
    },
    {
      'category': 'Motivation',
      'advice': 'The key to success is to focus on goals, not obstacles.',
    },
    {'category': 'Motivation', 'advice': 'Dream it. Believe it. Build it.'},
    {'category': 'Motivation', 'advice': 'Your only limit is you.'},
    {
      'category': 'Motivation',
      'advice': 'Push yourself, because no one else is going to do it for you.',
    },
    {
      'category': 'Motivation',
      'advice':
          'Great things are not achieved by those who yield to trends and fads.',
    },

    // Productivity (20)
    {
      'category': 'Productivity',
      'advice': 'Focus on being productive instead of busy.',
    },
    {
      'category': 'Productivity',
      'advice': 'The secret of getting ahead is getting started.',
    },
    {
      'category': 'Productivity',
      'advice': 'Do what you can, with what you have, where you are.',
    },
    {
      'category': 'Productivity',
      'advice': 'Either you run the day or the day runs you.',
    },
    {
      'category': 'Productivity',
      'advice': 'Action is the foundational key to all success.',
    },
    {
      'category': 'Productivity',
      'advice': 'The way to get started is to quit talking and begin doing.',
    },
    {
      'category': 'Productivity',
      'advice':
          'Efficiency is doing things right; effectiveness is doing the right things.',
    },
    {
      'category': 'Productivity',
      'advice': 'Until we can manage time, we can manage nothing else.',
    },
    {
      'category': 'Productivity',
      'advice':
          'You don\'t have to be great to start, but you have to start to be great.',
    },
    {
      'category': 'Productivity',
      'advice': 'Plans are nothing; planning is everything.',
    },
    {'category': 'Productivity', 'advice': 'Done is better than perfect.'},
    {
      'category': 'Productivity',
      'advice': 'The only way to do great work is to love what you do.',
    },
    {
      'category': 'Productivity',
      'advice': 'Start where you are. Use what you have. Do what you can.',
    },
    {
      'category': 'Productivity',
      'advice': 'Time is what we want most, but what we use worst.',
    },
    {
      'category': 'Productivity',
      'advice': 'Focus on priorities, not just activities.',
    },
    {'category': 'Productivity', 'advice': 'Work smarter, not harder.'},
    {
      'category': 'Productivity',
      'advice':
          'Your time is limited, don\'t waste it living someone else\'s life.',
    },
    {
      'category': 'Productivity',
      'advice':
          'The difference between ordinary and extraordinary is that little extra.',
    },
    {
      'category': 'Productivity',
      'advice': 'Simplicity is the ultimate sophistication.',
    },
    {'category': 'Productivity', 'advice': 'Make each day your masterpiece.'},

    // Success (20)
    {
      'category': 'Success',
      'advice':
          'Success is not final, failure is not fatal: it is the courage to continue that counts.',
    },
    {
      'category': 'Success',
      'advice':
          'The road to success and the road to failure are almost exactly the same.',
    },
    {
      'category': 'Success',
      'advice':
          'Success is walking from failure to failure with no loss of enthusiasm.',
    },
    {
      'category': 'Success',
      'advice':
          'The only place where success comes before work is in the dictionary.',
    },
    {
      'category': 'Success',
      'advice':
          'Success usually comes to those who are too busy to be looking for it.',
    },
    {
      'category': 'Success',
      'advice': 'Don\'t be afraid to give up the good to go for the great.',
    },
    {
      'category': 'Success',
      'advice': 'I find that the harder I work, the more luck I seem to have.',
    },
    {
      'category': 'Success',
      'advice':
          'Success is not how high you have climbed, but how you make a positive difference to the world.',
    },
    {
      'category': 'Success',
      'advice':
          'There are no secrets to success. It is the result of preparation, hard work, and learning from failure.',
    },
    {
      'category': 'Success',
      'advice':
          'Success is liking yourself, liking what you do, and liking how you do it.',
    },
    {
      'category': 'Success',
      'advice':
          'The successful warrior is the average man, with laser-like focus.',
    },
    {
      'category': 'Success',
      'advice': 'Success is not in what you have, but who you are.',
    },
    {
      'category': 'Success',
      'advice':
          'Don\'t aim for success if you want it; just do what you love and believe in.',
    },
    {
      'category': 'Success',
      'advice':
          'Success is the sum of small efforts repeated day in and day out.',
    },
    {
      'category': 'Success',
      'advice':
          'The secret of success is to do the common thing uncommonly well.',
    },
    {
      'category': 'Success',
      'advice':
          'Success seems to be connected with action. Successful people keep moving.',
    },
    {
      'category': 'Success',
      'advice':
          'Success is getting what you want. Happiness is wanting what you get.',
    },
    {
      'category': 'Success',
      'advice': 'The starting point of all achievement is desire.',
    },
    {
      'category': 'Success',
      'advice':
          'Success is not the key to happiness. Happiness is the key to success.',
    },
    {
      'category': 'Success',
      'advice':
          'The only limit to our realization of tomorrow is our doubts of today.',
    },

    // Creativity (20)
    {
      'category': 'Creativity',
      'advice': 'Creativity is intelligence having fun.',
    },
    {'category': 'Creativity', 'advice': 'Every artist was first an amateur.'},
    {'category': 'Creativity', 'advice': 'Creativity takes courage.'},
    {
      'category': 'Creativity',
      'advice':
          'You can\'t use up creativity. The more you use, the more you have.',
    },
    {
      'category': 'Creativity',
      'advice':
          'Think left and think right and think low and think high. Oh, the thinks you can think up if only you try!',
    },
    {
      'category': 'Creativity',
      'advice': 'Imagination is more important than knowledge.',
    },
    {
      'category': 'Creativity',
      'advice':
          'Creativity is allowing yourself to make mistakes. Art is knowing which ones to keep.',
    },
    {
      'category': 'Creativity',
      'advice': 'The creative adult is the child who survived.',
    },
    {
      'category': 'Creativity',
      'advice': 'Innovation distinguishes between a leader and a follower.',
    },
    {
      'category': 'Creativity',
      'advice':
          'The desire to create is one of the deepest yearnings of the human soul.',
    },
    {
      'category': 'Creativity',
      'advice': 'Creativity is contagious, pass it on.',
    },
    {
      'category': 'Creativity',
      'advice':
          'Ideas are like rabbits. You get a couple and learn how to handle them, and pretty soon you have a dozen.',
    },
    {
      'category': 'Creativity',
      'advice': 'The chief enemy of creativity is good sense.',
    },
    {
      'category': 'Creativity',
      'advice':
          'Creativity doesn\'t wait for that perfect moment. It fashions its own perfect moments.',
    },
    {
      'category': 'Creativity',
      'advice':
          'Logic will get you from A to B. Imagination will take you everywhere.',
    },
    {
      'category': 'Creativity',
      'advice':
          'The true sign of intelligence is not knowledge but imagination.',
    },
    {
      'category': 'Creativity',
      'advice':
          'An idea that is not dangerous is unworthy of being called an idea at all.',
    },
    {
      'category': 'Creativity',
      'advice': 'Creativity requires the courage to let go of certainties.',
    },
    {
      'category': 'Creativity',
      'advice': 'Originality is nothing but judicious imitation.',
    },
    {
      'category': 'Creativity',
      'advice': 'The worst enemy to creativity is self-doubt.',
    },

    // Wisdom (20)
    {
      'category': 'Wisdom',
      'advice': 'The only true wisdom is in knowing you know nothing.',
    },
    {'category': 'Wisdom', 'advice': 'Turn your wounds into wisdom.'},
    {
      'category': 'Wisdom',
      'advice': 'Knowing yourself is the beginning of all wisdom.',
    },
    {
      'category': 'Wisdom',
      'advice':
          'The fool doth think he is wise, but the wise man knows himself to be a fool.',
    },
    {
      'category': 'Wisdom',
      'advice':
          'By three methods we may learn wisdom: reflection, imitation, and experience.',
    },
    {
      'category': 'Wisdom',
      'advice': 'The only way to do great work is to love what you do.',
    },
    {
      'category': 'Wisdom',
      'advice': 'In the midst of chaos, there is also opportunity.',
    },
    {
      'category': 'Wisdom',
      'advice':
          'He who knows all the answers has not been asked all the questions.',
    },
    {
      'category': 'Wisdom',
      'advice': 'The journey of a thousand miles begins with one step.',
    },
    {
      'category': 'Wisdom',
      'advice':
          'A wise man can learn more from a foolish question than a fool can learn from a wise answer.',
    },
    {
      'category': 'Wisdom',
      'advice': 'The mind is everything. What you think you become.',
    },
    {'category': 'Wisdom', 'advice': 'Knowledge speaks, but wisdom listens.'},
    {
      'category': 'Wisdom',
      'advice':
          'It is not what happens to you, but how you react that matters.',
    },
    {
      'category': 'Wisdom',
      'advice': 'The greatest wisdom is seeing through appearances.',
    },
    {'category': 'Wisdom', 'advice': 'Wonder is the beginning of wisdom.'},
    {
      'category': 'Wisdom',
      'advice': 'The simplest things are often the truest.',
    },
    {
      'category': 'Wisdom',
      'advice':
          'It is better to remain silent and be thought a fool than to speak and remove all doubt.',
    },
    {
      'category': 'Wisdom',
      'advice': 'A smooth sea never made a skilled sailor.',
    },
    {
      'category': 'Wisdom',
      'advice': 'The wise man does at once what the fool does finally.',
    },
    {
      'category': 'Wisdom',
      'advice': 'Those who flow as life flows know they need no other force.',
    },

    // Growth (20)
    {
      'category': 'Growth',
      'advice': 'Don\'t watch the clock; do what it does. Keep going.',
    },
    {
      'category': 'Growth',
      'advice': 'The only impossible journey is the one you never begin.',
    },
    {
      'category': 'Growth',
      'advice':
          'Growth is painful. Change is painful. But nothing is as painful as staying stuck somewhere you don\'t belong.',
    },
    {
      'category': 'Growth',
      'advice': 'We cannot become what we want by remaining what we are.',
    },
    {
      'category': 'Growth',
      'advice': 'Life begins at the end of your comfort zone.',
    },
    {
      'category': 'Growth',
      'advice': 'There is no elevator to success. You have to take the stairs.',
    },
    {
      'category': 'Growth',
      'advice': 'Every next level of your life will demand a different you.',
    },
    {'category': 'Growth', 'advice': 'Strive for progress, not perfection.'},
    {
      'category': 'Growth',
      'advice': 'A year from now you may wish you had started today.',
    },
    {
      'category': 'Growth',
      'advice':
          'Change is hard at first, messy in the middle, and gorgeous at the end.',
    },
    {
      'category': 'Growth',
      'advice': 'You must be the change you wish to see in the world.',
    },
    {
      'category': 'Growth',
      'advice':
          'The master has failed more times than the beginner has even tried.',
    },
    {
      'category': 'Growth',
      'advice':
          'Be not afraid of growing slowly; be afraid only of standing still.',
    },
    {
      'category': 'Growth',
      'advice':
          'Yesterday I was clever, so I wanted to change the world. Today I am wise, so I am changing myself.',
    },
    {
      'category': 'Growth',
      'advice':
          'If you always do what you\'ve always done, you\'ll always get what you\'ve always got.',
    },
    {
      'category': 'Growth',
      'advice':
          'The only person you are destined to become is the person you decide to be.',
    },
    {
      'category': 'Growth',
      'advice': 'What you do today can improve all your tomorrows.',
    },
    {
      'category': 'Growth',
      'advice':
          'The secret of change is to focus all of your energy not on fighting the old, but on building the new.',
    },
    {
      'category': 'Growth',
      'advice': 'Small daily improvements over time lead to stunning results.',
    },
    {
      'category': 'Growth',
      'advice':
          'You are never too old to set another goal or to dream a new dream.',
    },

    // Courage (20)
    {
      'category': 'Courage',
      'advice': 'Life is 10% what happens to you and 90% how you react to it.',
    },
    {
      'category': 'Courage',
      'advice':
          'Courage is not the absence of fear, but rather the judgment that something else is more important than fear.',
    },
    {
      'category': 'Courage',
      'advice':
          'You gain strength, courage, and confidence by every experience in which you really stop to look fear in the face.',
    },
    {
      'category': 'Courage',
      'advice': 'It takes courage to grow up and become who you really are.',
    },
    {
      'category': 'Courage',
      'advice':
          'Courage is the most important of all the virtues because without courage, you can\'t practice any other virtue consistently.',
    },
    {
      'category': 'Courage',
      'advice': 'Have the courage to follow your heart and intuition.',
    },
    {
      'category': 'Courage',
      'advice':
          'Being deeply loved by someone gives you strength, while loving someone deeply gives you courage.',
    },
    {
      'category': 'Courage',
      'advice': 'Life shrinks or expands in proportion to one\'s courage.',
    },
    {
      'category': 'Courage',
      'advice':
          'Courage doesn\'t always roar. Sometimes courage is the quiet voice at the end of the day saying, "I will try again tomorrow."',
    },
    {
      'category': 'Courage',
      'advice':
          'The greatest test of courage on earth is to bear defeat without losing heart.',
    },
    {
      'category': 'Courage',
      'advice':
          'It is curious that physical courage should be so common in the world and moral courage so rare.',
    },
    {
      'category': 'Courage',
      'advice':
          'Courage is resistance to fear, mastery of fear—not absence of fear.',
    },
    {
      'category': 'Courage',
      'advice':
          'With courage you will dare to take risks, have the strength to be compassionate, and the wisdom to be humble.',
    },
    {'category': 'Courage', 'advice': 'Courage is knowing what not to fear.'},
    {
      'category': 'Courage',
      'advice':
          'All our dreams can come true if we have the courage to pursue them.',
    },
    {
      'category': 'Courage',
      'advice':
          'He who is not courageous enough to take risks will accomplish nothing in life.',
    },
    {'category': 'Courage', 'advice': 'Fortune favors the brave.'},
    {
      'category': 'Courage',
      'advice': 'Don\'t be afraid to give up the good to go for the great.',
    },
    {'category': 'Courage', 'advice': 'Courage is grace under pressure.'},
    {
      'category': 'Courage',
      'advice':
          'The brave may not live forever, but the cautious do not live at all.',
    },

    // Perseverance (20)
    {
      'category': 'Perseverance',
      'advice':
          'It does not matter how slowly you go as long as you do not stop.',
    },
    {
      'category': 'Perseverance',
      'advice':
          'Perseverance is not a long race; it is many short races one after the other.',
    },
    {'category': 'Perseverance', 'advice': 'Fall seven times, stand up eight.'},
    {
      'category': 'Perseverance',
      'advice':
          'The difference between a successful person and others is not a lack of strength, not a lack of knowledge, but rather a lack of will.',
    },
    {
      'category': 'Perseverance',
      'advice':
          'Success is the result of perfection, hard work, learning from failure, loyalty, and persistence.',
    },
    {
      'category': 'Perseverance',
      'advice':
          'Many of life\'s failures are people who did not realize how close they were to success when they gave up.',
    },
    {
      'category': 'Perseverance',
      'advice':
          'Rivers know this: there is no hurry. We shall get there some day.',
    },
    {
      'category': 'Perseverance',
      'advice':
          'It\'s not that I\'m so smart, it\'s just that I stay with problems longer.',
    },
    {
      'category': 'Perseverance',
      'advice': 'The only guarantee for failure is to stop trying.',
    },
    {
      'category': 'Perseverance',
      'advice':
          'Never give up on something you really want. It\'s difficult to wait, but worse to regret.',
    },
    {
      'category': 'Perseverance',
      'advice':
          'Character consists of what you do on the third and fourth tries.',
    },
    {
      'category': 'Perseverance',
      'advice':
          'The man who moves a mountain begins by carrying away small stones.',
    },
    {
      'category': 'Perseverance',
      'advice':
          'Our greatest weakness lies in giving up. The most certain way to succeed is always to try just one more time.',
    },
    {
      'category': 'Perseverance',
      'advice': 'A winner is just a loser who tried one more time.',
    },
    {
      'category': 'Perseverance',
      'advice':
          'Effort only fully releases its reward after a person refuses to quit.',
    },
    {
      'category': 'Perseverance',
      'advice': 'The harder the conflict, the more glorious the triumph.',
    },
    {
      'category': 'Perseverance',
      'advice': 'When you feel like quitting, think about why you started.',
    },
    {
      'category': 'Perseverance',
      'advice': 'Winners never quit, and quitters never win.',
    },
    {
      'category': 'Perseverance',
      'advice': 'Don\'t watch the clock; do what it does. Keep going.',
    },
    {
      'category': 'Perseverance',
      'advice':
          'The only way to do great work is to keep going even when you want to stop.',
    },

    // Learning (20)
    {
      'category': 'Learning',
      'advice':
          'The capacity to learn is a gift; the ability to learn is a skill; the willingness to learn is a choice.',
    },
    {
      'category': 'Learning',
      'advice':
          'Tell me and I forget. Teach me and I remember. Involve me and I learn.',
    },
    {
      'category': 'Learning',
      'advice':
          'Anyone who stops learning is old, whether at twenty or eighty.',
    },
    {
      'category': 'Learning',
      'advice':
          'Live as if you were to die tomorrow. Learn as if you were to live forever.',
    },
    {
      'category': 'Learning',
      'advice':
          'The beautiful thing about learning is that no one can take it away from you.',
    },
    {
      'category': 'Learning',
      'advice':
          'Education is the most powerful weapon which you can use to change the world.',
    },
    {
      'category': 'Learning',
      'advice': 'The expert in anything was once a beginner.',
    },
    {'category': 'Learning', 'advice': 'Learning never exhausts the mind.'},
    {
      'category': 'Learning',
      'advice': 'Change is the end result of all true learning.',
    },
    {
      'category': 'Learning',
      'advice':
          'The more that you read, the more things you will know. The more that you learn, the more places you\'ll go.',
    },
    {
      'category': 'Learning',
      'advice': 'An investment in knowledge pays the best interest.',
    },
    {
      'category': 'Learning',
      'advice': 'Learn from yesterday, live for today, hope for tomorrow.',
    },
    {
      'category': 'Learning',
      'advice': 'Study the past if you would define the future.',
    },
    {
      'category': 'Learning',
      'advice':
          'The mind is not a vessel to be filled, but a fire to be kindled.',
    },
    {
      'category': 'Learning',
      'advice':
          'I am always doing that which I cannot do, in order that I may learn how to do it.',
    },
    {
      'category': 'Learning',
      'advice': 'The only source of knowledge is experience.',
    },
    {
      'category': 'Learning',
      'advice':
          'Wisdom is not a product of schooling but of the lifelong attempt to acquire it.',
    },
    {
      'category': 'Learning',
      'advice': 'Learning is a treasure that will follow its owner everywhere.',
    },
    {
      'category': 'Learning',
      'advice':
          'Education is not preparation for life; education is life itself.',
    },
    {
      'category': 'Learning',
      'advice':
          'The cure for boredom is curiosity. There is no cure for curiosity.',
    },

    // Happiness (20)
    {
      'category': 'Happiness',
      'advice':
          'Happiness is not something ready made. It comes from your own actions.',
    },
    {
      'category': 'Happiness',
      'advice': 'The purpose of our lives is to be happy.',
    },
    {
      'category': 'Happiness',
      'advice':
          'Happiness is when what you think, what you say, and what you do are in harmony.',
    },
    {
      'category': 'Happiness',
      'advice':
          'Count your age by friends, not years. Count your life by smiles, not tears.',
    },
    {
      'category': 'Happiness',
      'advice':
          'For every minute you are angry you lose sixty seconds of happiness.',
    },
    {
      'category': 'Happiness',
      'advice': 'Happiness is not by chance, but by choice.',
    },
    {
      'category': 'Happiness',
      'advice':
          'The happiest people don\'t have the best of everything, they just make the best of everything.',
    },
    {
      'category': 'Happiness',
      'advice':
          'There is only one happiness in this life, to love and be loved.',
    },
    {'category': 'Happiness', 'advice': 'Happiness depends upon ourselves.'},
    {
      'category': 'Happiness',
      'advice': 'Be happy for this moment. This moment is your life.',
    },
    {
      'category': 'Happiness',
      'advice':
          'The greatest happiness you can have is knowing that you do not necessarily require happiness.',
    },
    {
      'category': 'Happiness',
      'advice':
          'Folks are usually about as happy as they make their minds up to be.',
    },
    {
      'category': 'Happiness',
      'advice': 'Happiness is not a goal; it is a by-product.',
    },
    {
      'category': 'Happiness',
      'advice':
          'The only way to find true happiness is to risk being completely cut open.',
    },
    {'category': 'Happiness', 'advice': 'Happiness is a warm puppy.'},
    {
      'category': 'Happiness',
      'advice': 'Don\'t cry because it\'s over, smile because it happened.',
    },
    {
      'category': 'Happiness',
      'advice':
          'Let us be grateful to people who make us happy; they are the charming gardeners who make our souls blossom.',
    },
    {
      'category': 'Happiness',
      'advice': 'Happiness is a direction, not a place.',
    },
    {
      'category': 'Happiness',
      'advice':
          'The best way to cheer yourself is to try to cheer someone else up.',
    },
    {
      'category': 'Happiness',
      'advice':
          'Happiness is not something you postpone for the future; it is something you design for the present.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _generateAdvice();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateAdvice() {
    _animationController.reset();
    final advice = _adviceList[_random.nextInt(_adviceList.length)];
    setState(() {
      _currentAdvice = advice['advice']!;
      _currentCategory = advice['category']!;
    });
    _animationController.forward();
  }

  Color _getCategoryColor(String category) {
    final colors = [
      CupertinoColors.systemBlue,
      CupertinoColors.systemPurple,
      CupertinoColors.systemPink,
      CupertinoColors.systemOrange,
      CupertinoColors.systemTeal,
      CupertinoColors.systemIndigo,
    ];
    final index = category.hashCode % colors.length;
    return colors[index.abs()];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Daily Wisdom')),
      child: GradientBackground(
        colors: [
          VisualEffectsConfig.adviceGradientStart,
          VisualEffectsConfig.adviceGradientEnd,
        ],
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getCategoryColor(_currentCategory),
                          _getCategoryColor(_currentCategory).withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: VisualEffectsConfig.createGlowEffect(
                        color: _getCategoryColor(_currentCategory),
                      ),
                    ),
                    child: PulsingGlow(
                      glowColor: _getCategoryColor(_currentCategory),
                      child: const Icon(
                        CupertinoIcons.lightbulb_fill,
                        size: 60,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (_currentCategory.isNotEmpty)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(
                            _currentCategory,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _currentCategory.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getCategoryColor(_currentCategory),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (_currentAdvice.isNotEmpty)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: GlassCard(
                        padding: const EdgeInsets.all(28),
                        showGlow: true,
                        glowColor: _getCategoryColor(_currentCategory),
                        child: Column(
                          children: [
                            const Icon(
                              CupertinoIcons.quote_bubble_fill,
                              size: 32,
                              color: CupertinoColors.systemGrey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _currentAdvice,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                  GradientButton(
                    text: 'Get New Advice',
                    onPressed: _generateAdvice,
                    gradientColors: [
                      _getCategoryColor(_currentCategory),
                      _getCategoryColor(_currentCategory).withOpacity(0.7),
                    ],
                    showGlow: true,
                    glowColor: _getCategoryColor(_currentCategory),
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Tap the button to receive\ninspiration for your day',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 237, 237, 245),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
