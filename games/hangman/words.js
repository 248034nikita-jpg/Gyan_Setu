var WORDS = {

    // ---------- MAMMALS ----------
    mammals: {
        easy: [
            { word: 'CAT', hint: 'A small furry pet', meaning: 'A small pet that purrs.', fact: 'Cats purr when happy!', image: '🐱' },
            { word: 'DOG', hint: 'A friendly barker', meaning: 'A loyal pet.', fact: 'Dogs understand 250 words!', image: '🐶' },
            { word: 'COW', hint: 'A farm animal that gives milk', meaning: 'A farm animal.', fact: 'Cows have 4 stomachs!', image: '🐄' },
            { word: 'PIG', hint: 'A pink farm animal', meaning: 'A smart pink animal.', fact: 'Pigs are smarter than dogs!', image: '🐷' },
            { word: 'BAT', hint: 'The only flying mammal', meaning: 'The only mammal that can fly.', fact: 'Bats use echolocation!', image: '🦇' },
            { word: 'FOX', hint: 'A clever orange animal', meaning: 'A smart animal.', fact: 'Foxes use tails for warmth!', image: '🦊' },
            { word: 'BEAR', hint: 'A big furry animal', meaning: 'A large animal that hibernates.', fact: 'Bears run as fast as horses!', image: '🐻' },
            { word: 'DEER', hint: 'A graceful animal with antlers', meaning: 'A beautiful animal.', fact: 'Deer grow new antlers yearly!', image: '🦌' },
            { word: 'ZEBRA', hint: 'A striped horse-like animal', meaning: 'An African animal with stripes.', fact: 'Every zebra has unique stripes!', image: '🦓' }
        ],
        medium: [
            { word: 'TIGER', hint: 'A large striped cat', meaning: 'The largest cat species.', fact: 'Tiger stripes are unique!', image: '🐯' },
            { word: 'RABBIT', hint: 'A hopping animal with long ears', meaning: 'A small furry hopper.', fact: 'Rabbits jump 10x their length!', image: '🐰' },
            { word: 'HORSE', hint: 'A large animal used for riding', meaning: 'A strong animal.', fact: 'Horses sleep standing up!', image: '🐴' },
            { word: 'MONKEY', hint: 'A playful tree-dweller', meaning: 'A clever animal.', fact: 'Monkeys use tools!', image: '🐵' },
            { word: 'LION', hint: 'The king of the jungle', meaning: 'A powerful cat.', fact: 'Lion roars heard 5 miles away!', image: '🦁' }
        ],
        hard: [
            { word: 'ELEPHANT', hint: 'The largest land animal', meaning: 'The largest land animal.', fact: 'Elephants can\'t jump!', image: '🐘' },
            { word: 'GIRAFFE', hint: 'The tallest land animal', meaning: 'The tallest animal.', fact: 'Giraffes have purple tongues!', image: '🦒' },
            { word: 'DOLPHIN', hint: 'A smart sea animal', meaning: 'A very intelligent sea mammal.', fact: 'Dolphins have names!', image: '🐬' },
            { word: 'KANGAROO', hint: 'An animal with a pouch', meaning: 'An Australian animal.', fact: 'Kangaroos hop 35 mph!', image: '🦘' }
        ]
    },

    // ---------- BIRDS ----------
    birds: {
        easy: [
            { word: 'DUCK', hint: 'A bird that says quack', meaning: 'A water bird.', fact: 'Duck feathers are waterproof!', image: '🦆' },
            { word: 'HEN', hint: 'A bird that lays eggs', meaning: 'A female chicken.', fact: 'Hens lay 300 eggs yearly!', image: '🐔' },
            { word: 'OWL', hint: 'A night bird', meaning: 'A bird that hunts at night.', fact: 'Owls turn heads 270°!', image: '🦉' },
            { word: 'EAGLE', hint: 'A large bird with sharp eyes', meaning: 'A powerful bird.', fact: 'Eagles see 8x better!', image: '🦅' },
            { word: 'PENGUIN', hint: 'A bird that swims', meaning: 'A bird that swims but cannot fly.', fact: 'Penguins swim 22 mph!', image: '🐧' }
        ],
        medium: [
            { word: 'PARROT', hint: 'A colorful talking bird', meaning: 'A smart bird.', fact: 'Parrots learn 100+ words!', image: '🦜' },
            { word: 'SPARROW', hint: 'A small brown bird', meaning: 'A common bird.', fact: 'Sparrows are social!', image: '🐦' }
        ],
        hard: [
            { word: 'FLAMINGO', hint: 'A pink bird on one leg', meaning: 'A pink bird.', fact: 'Flamingos turn pink from shrimp!', image: '🦩' },
            { word: 'PELICAN', hint: 'A bird with a big beak pouch', meaning: 'A bird that catches fish.', fact: 'Pelicans hold 3 gallons!', image: '🐦' }
        ]
    },

    // ---------- REPTILES ----------
    reptiles: {
        easy: [
            { word: 'SNAKE', hint: 'A long animal with no legs', meaning: 'A legless animal.', fact: 'Snakes smell with tongues!', image: '🐍' },
            { word: 'LIZARD', hint: 'A small animal that can lose its tail', meaning: 'A reptile.', fact: 'Lizards change color!', image: '🦎' },
            { word: 'TURTLE', hint: 'A slow animal with a shell', meaning: 'A reptile with a shell.', fact: 'Turtles live 150 years!', image: '🐢' }
        ],
        medium: [
            { word: 'CROCODILE', hint: 'A large reptile with many teeth', meaning: 'A powerful water reptile.', fact: 'Crocodiles hold breath 1 hour!', image: '🐊' },
            { word: 'IGUANA', hint: 'A green sun-loving reptile', meaning: 'A large green reptile.', fact: 'Iguanas have a third eye!', image: '🦎' }
        ],
        hard: [
            { word: 'CHAMELEON', hint: 'A reptile that changes color', meaning: 'A reptile famous for changing color.', fact: 'Chameleons look two ways!', image: '🦎' },
            { word: 'ALLIGATOR', hint: 'A large reptile with a broad snout', meaning: 'A reptile similar to a crocodile.', fact: 'Alligators lived with dinosaurs!', image: '🐊' }
        ]
    },

    // ---------- AMPHIBIANS ----------
    amphibians: {
        easy: [
            { word: 'FROG', hint: 'A small animal that says ribbit', meaning: 'A jumping animal.', fact: 'Frogs jump 20x their length!', image: '🐸' },
            { word: 'TOAD', hint: 'A bumpy animal like a frog', meaning: 'A bumpy amphibian.', fact: 'Toads release bad-tasting substance!', image: '🐸' }
        ],
        medium: [
            { word: 'SALAMANDER', hint: 'A long animal that looks like a lizard', meaning: 'A long amphibian.', fact: 'Salamanders regrow body parts!', image: '🦎' }
        ],
        hard: [
            { word: 'AXOLOTL', hint: 'A unique animal that stays young', meaning: 'A special salamander.', fact: 'Axolotls regrow their brain!', image: '🦎' }
        ]
    }
};