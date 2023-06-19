# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
Enum.map(
  [
    %{author: "Sterling K. Brown", body: "Always have an attitude of gratitude."},
    %{
      author: "John F. Kennedy",
      body:
        "As we express our gratitude, we must never forget that the highest appreciation is not to utter words, but to live by them."
    },
    %{
      author: "Michelle Obama",
      body:
        "We learned about gratitude and humility - that so many people had a hand in our success."
    },
    %{author: "Doris Day", body: "Gratitude is riches. Complaint is poverty."},
    %{
      author: "Andra Day",
      body: "I think gratitude is a big thing. It puts you in a place where you’re humble."
    },
    %{
      author: "Maya Angelou",
      body: "This is a wonderful day. I have never seen this one before."
    },
    %{
      author: "Kristin Armstrong",
      body:
        "When we focus on our gratitude, the tide of disappointment goes out and the tide of love rushes in."
    },
    %{
      author: "Ralph Waldo Emerson",
      body: "I awoke this morning with devout thanksgiving for my friends, the old and the new."
    },
    %{
      author: "Voltaire",
      body:
        "Appreciation is a wonderful thing. It makes what is excellent in others belong to us as well."
    },
    %{
      author: "Tecumseh",
      body:
        "When you arise in the morning give thanks for the food and for the joy of living. If you see no reason for giving thanks, the fault lies only in yourself."
    },
    %{
      author: "Vietnamese Proverb",
      body: "When eating fruit, remember the one who planted the tree."
    },
    %{
      author: "Irving Berlin",
      body:
        "Got no checkbooks, got no banks, still I’d like to express my thanks. I got the sun in the morning and the moon at night."
    },
    %{
      author: "Charlotte Brontë",
      body:
        "For my part, I am almost contented just now, and very thankful. Gratitude is a divine emotion: it fills the heart, but not to bursting; it warms it, but not to fever."
    },
    %{author: "James Allen", body: "No duty is more urgent than giving thanks."},
    %{
      author: "Willie Nelson",
      body: "When I started counting my blessings, my whole life turned around."
    },
    %{
      author: "G.K. Chesterton",
      body:
        "I would maintain that thanks are the highest form of thought; and that gratitude is happiness doubled by wonder."
    },
    %{
      author: "Robert Brault",
      body:
        "Enjoy the little things, for one day you may look back and realize they were the big things."
    },
    %{author: "Buddhist Proverb", body: "'Enough' is a feast."},
    %{
      author: "Melody Beattie",
      body:
        "Gratitude turns what we have into enough, and more. It turns denial into acceptance, chaos into order, confusion into clarity...it makes sense of our past, brings peace for today, and creates a vision for tomorrow."
    },
    %{
      author: "Epictetus",
      body:
        "He is a wise man who does not grieve for the things which he has not, but rejoices for those which he has."
    },
    %{
      author: "Germany Kent",
      body:
        "It’s a funny thing about life, once you begin to take note of the things you are grateful for, you begin to lose sight of the things that you lack."
    },
    %{
      author: "Douglas Wood",
      body:
        "The heart that gives thanks is a happy one, for we cannot feel thankful and unhappy at the same time."
    },
    %{
      author: "A.A. Milne",
      body:
        "Piglet noticed that even though he had a Very Small Heart, it could hold a rather large amount of Gratitude."
    },
    %{
      author: "Dietrich Bonhoeffer",
      body:
        "In ordinary life, we hardly realize that we receive a great deal more than we give, and that it is only with gratitude that life becomes rich."
    },
    %{
      author: "Rumi",
      body: "Wear gratitude like a cloak, and it will feed every corner of your life."
    },
    %{
      author: "Marcel Proust",
      body:
        "Let us be grateful to the people who make us happy; they are the charming gardeners who make our souls blossom."
    },
    %{
      author: "Epicurus",
      body:
        "Do not spoil what you have by desiring what you have not; remember that what you now have was once among the things you only hoped for."
    },
    %{
      author: "Oprah",
      body: "True forgiveness is when you can say, 'Thank you for the experience.'"
    },
    %{
      author: "Ralph Waldo Emerson",
      body:
        "Cultivate the habit of being grateful for every good thing that comes to you, and to give thanks continuously. And because all things have contributed to your advancement, you should include all things in your gratitude."
    },
    %{
      author: "Maya Angelou",
      body:
        "Let gratitude be the pillow upon which you kneel to say your nightly prayer. And let faith be the bridge you build to overcome evil and welcome good."
    },
    %{
      author: "Meister Eckhart",
      body: "If the only prayer you said was thank you, that would be enough."
    },
    %{
      author: "John F. Kennedy",
      body: "We must find time to stop and thank the people who make a difference in our lives."
    },
    %{
      author: "Marcus Tullius Cicero",
      body: "Gratitude is not only the greatest of virtues, but the parent of all others."
    },
    %{
      author: "C.S. Lewis",
      body:
        "Gratitude looks to the Past and love to the Present; fear, avarice, lust, and ambition look ahead."
    },
    %{
      author: "Henry Ward Beecher",
      body:
        "The unthankful heart discovers no mercies; but the thankful heart will find, in every hour, some heavenly blessings."
    },
    %{author: "Brené Brown", body: "What separates privilege from entitlement is gratitude."},
    %{
      author: "G.K. Chesterton",
      body:
        "When it comes to life the critical thing is whether you take things for granted or take them with gratitude."
    },
    %{
      author: "John Ortberg",
      body:
        "Gratitude is the ability to experience life as a gift. It liberates us from the prison of self-preoccupation."
    },
    %{
      author: "Hannah Whitall Smith",
      body:
        "The soul that gives thanks can find comfort in everything; the soul that complains can find comfort in nothing."
    },
    %{
      author: "William Shakespeare",
      body: "O Lord that lends me life, lend me a heart replete with thankfulness."
    },
    %{
      author: "Amy Collette",
      body:
        "Gratitude is a powerful catalyst for happiness. It’s the spark that lights a fire of joy in your soul."
    },
    %{
      author: "Paul David Tripp",
      body:
        "If you fail to carry around with you a heart of gratitude for the love you’ve been so freely given, it is easy for you not to love others as you should."
    },
    %{
      author: "Charles Dickens",
      body:
        "Reflect upon your present blessings, of which every man has plenty; not on your past misfortunes, of which all men have some."
    },
    %{
      author: "Robert Braathe",
      body: "Gratitude and attitude are not challenges; they are choices."
    },
    %{
      author: "Thornton Wilder",
      body:
        "We can only be said to be alive in those moments when our hearts are conscious of our treasures."
    },
    %{author: "Karl Barth", body: "Joy is the simplest form of gratitude."},
    %{author: "Aesop", body: "Gratitude is the sign of noble souls."},
    %{author: "William Wordsworth", body: "Rest and be thankful."},
    %{
      author: "Anne Frank",
      body:
        "I lie in bed at night, after ending my prayers with the words 'Ich danke dir für all das Gute und Liebe und Schöne.' (Thank you, God, for all that is good and dear and beautiful.)"
    },
    %{author: "Marissa Meyer", body: "I’m still thanking all the stars, one by one."},
    %{author: "Jefferson Bethke", body: "Thankfulness is the quickest path to joy."},
    %{
      author: "John Milton",
      body: "Gratitude bestows reverence...changing forever how we experience life and the world."
    },
    %{
      author: "Henri J.M. Nouwen",
      body:
        "Gratitude goes beyond the 'mine' and 'thine' and claims the truth that all of life is a pure gift."
    },
    %{
      author: "Margaret Cousins",
      body:
        "Appreciation can make a day, even change a life. Your willingness to put it into words is all that is necessary."
    },
    %{
      author: "Helen Ellis",
      body: "There’s nothing nicer than unexpected appreciation. If you’re grateful, get a pen,"
    },
    %{
      author: "Rupi Kaur",
      body:
        "I thank the universe for taking everything it has taken and giving to me everything it is giving"
    },
    %{
      author: "John Green",
      body:
        "What an astonishment to breathe on this breathing planet. What a blessing to be Earth loving Earth,"
    },
    %{
      author: "Roy T. Bennett",
      body:
        "Always remember people who have helped you along the way, and don't forget to lift someone up,"
    },
    %{
      author: "Mindy Kaling",
      body: "Gratitude is the closest thing to beauty manifested in an emotion."
    },
    %{
      author: "Arianna Huffington",
      body: "Living in a state of gratitude is the gateway to grace."
    },
    %{
      author: "Eckhart Tolle",
      body:
        "Acknowledging the good that you already have in your life is the foundation for all abundance."
    },
    %{
      author: "Kyo Maclear",
      body:
        "Each day brings new opportunities, allowing you to constantly live with love—be there for others—bring a little light into someone's day. Be grateful and live each day to the fullest."
    },
    %{
      author: "Chris Matakas",
      body: "In the modern world, we are surrounded by so much abundance that we cannot see it."
    },
    %{
      author: "J.S. Mason",
      body: "The only thing you should feel entitled to is gratitude."
    }
  ],
  fn %{author: author, body: text} ->
    GratitudeEx.Repo.insert!(%GratitudeEx.Quotes.Quote{author: author, text: text})
  end
)
