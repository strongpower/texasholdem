# Texas Hold'em

## Description

In the era of contemporary blockchain technology, privacy and decentralization have revolutionized the way we interact with digital systems. Aleo takes privacy protection to an entirely new level, and in this context, I have created a Texas Hold'em poker contract that leverages Aleo's privacy capabilities, seamlessly merging the classic poker game with advanced privacy features.

This contract not only ensures user privacy but also retains the core gameplay of Texas Hold'em poker. Players can engage in the game within a fully decentralized environment, enjoying a transparent and fair gameplay experience without concerns about privacy breaches.

The contract's implementation of "hole cards" and "community cards" captures the essence of Texas Hold'em poker. Leveraging Aleo's robust privacy capabilities, a player's private cards remain invisible on the blockchain, only decrypted during specific phases of the game. This guarantees both game fairness and player privacy. This design allows players to relish a gameplay experience similar to traditional Texas Hold'em without worrying about information leaks.

## Why it would add value to the Aleo ecosystem

It will significantly enhance the value of the Aleo ecosystem, showcasing its impact not only in terms of technological innovation but also across various other dimensions:

**1. Technological Innovation and Privacy Protection:** By incorporating a multi-party composite pseudo-random number generation algorithm, the contract bestows upon the Aleo ecosystem a distinctive blend of privacy protection and fairness. The fusion of individual player's random factors with the dealer's contributes to the assurance of gameplay randomness. This technological innovation not only amplifies the contract's competitiveness but also elevates Aleo's standing as a pioneer in the field of privacy protection. Moreover, utilizing the bitstring approach, the contract simulates array-like functionality within the Leo environment and also introduces algorithms for bit swapping within integer numbers.

**2. Popularity of Texas Hold'em:** As a globally popular poker game, the implementation of Texas Hold'em will attract a vast number of existing enthusiasts, introducing new users to the Aleo ecosystem and fostering its expansion.

**3. Enhanced Community Engagement:** Multiplayer Texas Hold'em encourages active player interaction, reinforcing community cohesion and cultivating a more vibrant atmosphere within the Aleo ecosystem.

**4. Elevated Platform Visibility:** Leveraging the prominence of Texas Hold'em, the Aleo platform can garner increased media exposure, consequently bolstering its influence in the realm of cryptography and blockchain.

**5. Diversified Application Scenarios:** The introduction of Texas Hold'em introduces novel application scenarios to the Aleo platform, transitioning it from a singular privacy protection entity into a diversified ecosystem.

**6. Developer Incentives:** This contract not only exemplifies technological innovation but also serves as a model for developers, spurring them to create innovative applications within the Aleo ecosystem.

Through contributions spanning technological innovation, the implementation of a popular game, the attraction of new users, an enriched community dynamic, heightened platform recognition, and the expansion of application scenarios, this Texas Hold'em contract stands to augment the value of the Aleo ecosystem. Its impact extends beyond merely enriching ecosystem applications, to establishing a new benchmark in the blockchain arena.

## How to run

Before we begin, since there are 52 cards in the game, we choose one byte to represent one card, so u64 can be used to represent 8 cards. We define the id of each card as below:

## Rule

| Number\Suit | ♠️  | ♥️  | ♣️  | ♦️  |
| ----------- | --- | --- | --- |:--- |
| A           | 0   | 13  | 26  | 39  |
| K           | 1   | 14  | 27  | 40  |
| Q           | 2   | 15  | 28  | 41  |
| J           | 3   | 16  | 29  | 42  |
| 10          | 4   | 17  | 30  | 43  |
| 9           | 5   | 18  | 31  | 44  |
| 8           | 6   | 19  | 32  | 45  |
| 7           | 7   | 20  | 33  | 46  |
| 6           | 8   | 21  | 34  | 47  |
| 5           | 9   | 22  | 35  | 48  |
| 4           | 10  | 23  | 36  | 49  |
| 3           | 11  | 24  | 37  | 50  |
| 2           | 12  | 25  | 38  | 51  |

### 1. Initializing the Players and the Dealer

In order to play Texas Hold'em, there will be four players and one dealer. Participant will be represented by their Aleo address. You can use the provided accounts or generate your own.

```
Dealer:
     Private Key  APrivateKey1zkpG1uH9TvrNuT59QcwxTTy9LMNusarvxgYRNUoqW9KZxXV
     View Key  AViewKey1uSb88fA3iWZkShBdo6QhgeCeki58QuDMCaNm7nnADDeY
     Address  aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h

Player0:
     Private Key  APrivateKey1zkpEh5pce3a9rZ1DbZF1BZCr2tNHZmDM7cJsYTsdppSgaWK
     View Key  AViewKey1rDjXUK9Pkm2FgjN7xCc8RViK7bYjfqNRbK7g7JvcCten
     Address  aleo1xjyvhfdeuwt7q84tlq2vdvrlrkpvaksu96hz8enlzy7nthmq4vxssef92k

Player1:
     Private Key  APrivateKey1zkp3V4DMmPy4WtXck35wYFNr6vBUqsuZyVP1vrodbxNWbGj
     View Key  AViewKey1n51Du2a8XekzBtfgj2sv1ULRZAudd35rY123GY4CfNZD
     Address  aleo1wug20mqdxtkwqwnw4qjzyfna843d8mt77mcgpf2dfv48luduzq9sw4vpxr

Player2:
     Private Key  APrivateKey1zkp5f4MhHDvdbia2qqHL1ALg2pA52XQtpPZASkC3y59dHvg
     View Key  AViewKey1n62CeiEhDJ2m1U4F2tLUFkovnfYe7pU9hV7DLEsRoQh6
     Address  aleo14lrrqg3lt088jdtdncpxrjxccy7pf8heq7svejwz3lc0vq7lvy8sstn9xd

Player3:
     Private Key  APrivateKey1zkp7kFCLEoro6VE3JNybKoMbpkeyL49Nz9fWBqMyNfTnNoA
     View Key  AViewKey1p1yLi2rXtewxpEDnvxKnQT254hgx3E6TRVNHkLn1dvt2
     Address  aleo1d0mwekavg4yz3qe53h9ed9pgc62yg62dggvtkqhsud23av35cq8qzaca2e
```

Save the keys and addresses. Set the .env private key to the dealer.

```.env
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpG1uH9TvrNuT59QcwxTTy9LMNusarvxgYRNUoqW9KZxXV
```

### 2. The dealer start a new round

We use a multi-party composite pseudo-random number generation algorithm, which need the dealer and all the players to privide random seed to generating a random. So in this step, the dealer should generate a u64 random seed. For example, we use Rust to generate a random, you can use [it](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=cfacd8f85c2f424f77d0ae3d9ddbe9db) too.

Here the dealer start round 0, with random seed 10673168331723460832.

**Run**

```shell
leo run new_round 0u32 aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h 10673168331723460832u64
```

The output is a Record type, which is a random seed that only the dealer can know.

**Output**

```shell
➡️  Output

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  provider: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  round: 0u32.private,
  seed: 10673168331723460832u64.private,
  _nonce: 8229725957301631054315806920137366404737407654805262648750705340779560727854group.public
}
```

### 3. Player place their bets to participate the round

Each player need to place his bet to participate the round, meanwhile with a random seed. Again, we use Rust to generate random seed.

#### 3.1 Player0 places his bets

Set the .env private key to the player0.

```json
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpEh5pce3a9rZ1DbZF1BZCr2tNHZmDM7cJsYTsdppSgaWK
```

Now player0 place his bets, he need to provider the round number, the dealer's address, and a random seed.

**Run**

```
leo run place_bets 0u32 aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h 4778256655383446501u64
```

The output is a Record type random seed just like above the dealer made.

**Output**

```shell
➡️  Output

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  provider: aleo1xjyvhfdeuwt7q84tlq2vdvrlrkpvaksu96hz8enlzy7nthmq4vxssef92k.private,
  round: 0u32.private,
  seed: 4778256655383446501u64.private,
  _nonce: 5598863814122388284466442648888748817740654184772494410785573531413585043358group.public
}
```

#### 3.2 Player1 places his bet

Set the .env private key to the player1.

```json
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp3V4DMmPy4WtXck35wYFNr6vBUqsuZyVP1vrodbxNWbGj
```

**Run**

```
leo run place_bets 0u32 aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h 16656731793893744001u64
```

**Output**

```shell
➡️  Output

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  provider: aleo1wug20mqdxtkwqwnw4qjzyfna843d8mt77mcgpf2dfv48luduzq9sw4vpxr.private,
  round: 0u32.private,
  seed: 16656731793893744001u64.private,
  _nonce: 6096225498399927992484268770096084727411567482208132883304710201681366095259group.public
}
```

#### 3.3 Player2 places his bet

Set the .env private key to the player2.

```json
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp5f4MhHDvdbia2qqHL1ALg2pA52XQtpPZASkC3y59dHvg
```

**Run**

```
leo run place_bets 0u32 aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h 3295450932433379985u64
```

**Output**

```shell
➡️  Output

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  provider: aleo14lrrqg3lt088jdtdncpxrjxccy7pf8heq7svejwz3lc0vq7lvy8sstn9xd.private,
  round: 0u32.private,
  seed: 3295450932433379985u64.private,
  _nonce: 2220395015690359827055116704829787483947955736022271267733215478729241822599group.public
}
```

### 3.4 Player3 places his bet

Set the .env private key to the player3.

```json
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp7kFCLEoro6VE3JNybKoMbpkeyL49Nz9fWBqMyNfTnNoA
```

**Run**

```
leo run place_bets 0u32 aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h 6935347278321384095u64
```

**Output**

```shell
➡️  Output

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  provider: aleo1d0mwekavg4yz3qe53h9ed9pgc62yg62dggvtkqhsud23av35cq8qzaca2e.private,
  round: 0u32.private,
  seed: 6935347278321384095u64.private,
  _nonce: 808735556868920532973336578413058303554466034462614050407325046371606483386group.public
}
```

### 4. The dealer shuffling the cards

The dealer now uses players' 4 random seeds and his own random seed to generate a random, and shuffling the cards. All these random seeds are record types.

Set the .env private key to the dealer.

```json
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpG1uH9TvrNuT59QcwxTTy9LMNusarvxgYRNUoqW9KZxXV
```

**Run**

```shell
leo run -d shuffling 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  provider: aleo1xjyvhfdeuwt7q84tlq2vdvrlrkpvaksu96hz8enlzy7nthmq4vxssef92k.private,
  round: 0u32.private,
  seed: 4778256655383446501u64.private,
  _nonce: 5598863814122388284466442648888748817740654184772494410785573531413585043358group.public
}" "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  provider: aleo1wug20mqdxtkwqwnw4qjzyfna843d8mt77mcgpf2dfv48luduzq9sw4vpxr.private,
  round: 0u32.private,
  seed: 16656731793893744001u64.private,
  _nonce: 6096225498399927992484268770096084727411567482208132883304710201681366095259group.public
}" "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  provider: aleo14lrrqg3lt088jdtdncpxrjxccy7pf8heq7svejwz3lc0vq7lvy8sstn9xd.private,
  round: 0u32.private,
  seed: 3295450932433379985u64.private,
  _nonce: 2220395015690359827055116704829787483947955736022271267733215478729241822599group.public
}" "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  provider: aleo1d0mwekavg4yz3qe53h9ed9pgc62yg62dggvtkqhsud23av35cq8qzaca2e.private,
  round: 0u32.private,
  seed: 6935347278321384095u64.private,
  _nonce: 808735556868920532973336578413058303554466034462614050407325046371606483386group.public
}" "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  provider: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  round: 0u32.private,
  seed: 10673168331723460832u64.private,
  _nonce: 8229725957301631054315806920137366404737407654805262648750705340779560727854group.public
}"
```

We have shuffled the cards! The cards is only known by the dealer, players don't know.

**Output**

```shell
➡️  Output

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 0u8.private,
  _nonce: 5626282272018312166865033477705905390031140897085883587345358597001176490765group.public
}
```

### 5. Deal the hand

Now it's time to deal the hand to each player in order!

#### 5.1 Deal the hand to player0

First hole card to player0.

**Run**

```shell
leo run deal_the_hand 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 0u8.private,
  _nonce: 5626282272018312166865033477705905390031140897085883587345358597001176490765group.public
}" aleo1xjyvhfdeuwt7q84tlq2vdvrlrkpvaksu96hz8enlzy7nthmq4vxssef92k
```

Get a updated cards and one hole card to player0. 

**Output**

```shell
➡️  Outputs

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 1u8.private,
  _nonce: 5770430366573181693323276189505294396607561891224525004120239735981295980125group.public
}
 • {
  owner: aleo1xjyvhfdeuwt7q84tlq2vdvrlrkpvaksu96hz8enlzy7nthmq4vxssef92k.private,
  round: 0u32.private,
  id: 48u64.private,
  _nonce: 6378733323186963231481352064100909218505757489494731107078768139531991516446group.public
}
```

As we can see, the first hole card of player0 is 48, lookup from [Rule](##Rule), it's a 5 of ♦️.

#### 5.2 Deal the hand to player1

Use updated cards to deal the hand to player1.

**Run**

```shell
leo run deal_the_hand 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 1u8.private,
  _nonce: 5770430366573181693323276189505294396607561891224525004120239735981295980125group.public
}" aleo1wug20mqdxtkwqwnw4qjzyfna843d8mt77mcgpf2dfv48luduzq9sw4vpxr
```

Get a updated cards and one hole card to player1.

**Output**

```shell
➡️  Outputs

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 2u8.private,
  _nonce: 2504645910626388889437641770057281642714951936079216710057732916660876358373group.public
}
 • {
  owner: aleo1wug20mqdxtkwqwnw4qjzyfna843d8mt77mcgpf2dfv48luduzq9sw4vpxr.private,
  round: 0u32.private,
  id: 43u64.private,
  _nonce: 3157914141585982533317297797722808129268386513182953090292238683972721688591group.public
}
```

Again, as we can see, the first hole card of player1 is 43, lookup from [Rule](##Rule), it's a 10 of ♦️.

#### 5.3 Deal the hand to player2

Use updated cards to deal the hand to player2.

**Run**

```shell
leo run deal_the_hand 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 2u8.private,
  _nonce: 2504645910626388889437641770057281642714951936079216710057732916660876358373group.public
}" aleo14lrrqg3lt088jdtdncpxrjxccy7pf8heq7svejwz3lc0vq7lvy8sstn9xd
```

Get a updated cards and one hole card to player2.

**Output**

```shell
➡️  Outputs

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 3u8.private,
  _nonce: 3311173800554712696013630328349520744504740667603670110961246865603886344315group.public
}
 • {
  owner: aleo14lrrqg3lt088jdtdncpxrjxccy7pf8heq7svejwz3lc0vq7lvy8sstn9xd.private,
  round: 0u32.private,
  id: 9u64.private,
  _nonce: 4986689982864217550308627758492387771386739735916949589669725252594466626262group.public
}
```

Again, as we can see, the first hole card of player2 is 9, lookup from [Rule](##Rule), it's a 5 of ♠️.

#### 5.4 Deal the hand to player3

Use updated cards to deal the hand to player3.

**Run**

```shell
leo run deal_the_hand 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 3u8.private,
  _nonce: 3311173800554712696013630328349520744504740667603670110961246865603886344315group.public
}" aleo1d0mwekavg4yz3qe53h9ed9pgc62yg62dggvtkqhsud23av35cq8qzaca2e
```

Get a updated cards and one hole card to player3.

**Output**

```shell
➡️  Outputs

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 4u8.private,
  _nonce: 6556567273332005530199276955521858600756298270216159860424471218400383931295group.public
}
 • {
  owner: aleo1d0mwekavg4yz3qe53h9ed9pgc62yg62dggvtkqhsud23av35cq8qzaca2e.private,
  round: 0u32.private,
  id: 13u64.private,
  _nonce: 550190331851291490782453786647988716049414816386351260460997247271250108554group.public
}
```

Again, as we can see, the first hole card of player3 is 13, lookup from [Rule](##Rule), it's a A of ♥️.

#### 5.5 Deal the hand to players again

Just like above, the dealer need to deal the hand again to give each player two hole cards.

##### Player0's second hole card

**Run**

```shell
leo run deal_the_hand 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 4u8.private,
  _nonce: 6556567273332005530199276955521858600756298270216159860424471218400383931295group.public
}" aleo1xjyvhfdeuwt7q84tlq2vdvrlrkpvaksu96hz8enlzy7nthmq4vxssef92k
```

**Output**

```shell
➡️  Outputs

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 5u8.private,
  _nonce: 8403377614769885106179825423717869088745164708423724538523501479972295837086group.public
}
 • {
  owner: aleo1xjyvhfdeuwt7q84tlq2vdvrlrkpvaksu96hz8enlzy7nthmq4vxssef92k.private,
  round: 0u32.private,
  id: 23u64.private,
  _nonce: 4156991754494796320626407581079088923218893692388759117059226818326041093842group.public
}
```

Player0's second hole card is 23, which is 4 of ♥️.

##### Player1's second hole card

**Run**

```shell
leo run deal_the_hand 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 5u8.private,
  _nonce: 8403377614769885106179825423717869088745164708423724538523501479972295837086group.public
}" aleo1wug20mqdxtkwqwnw4qjzyfna843d8mt77mcgpf2dfv48luduzq9sw4vpxr
```

**Output**

```shell
➡️  Outputs

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 6u8.private,
  _nonce: 3187378664838095371413816402520861035009492614579850711233114485947770291789group.public
}
 • {
  owner: aleo1wug20mqdxtkwqwnw4qjzyfna843d8mt77mcgpf2dfv48luduzq9sw4vpxr.private,
  round: 0u32.private,
  id: 4u64.private,
  _nonce: 830764277915085358430578601770062189530737248156740656831334617808385044350group.public
}
```

Player1's second hole card is 4, which is 10 of ♠️.

##### Player2's second hole card

**Run**

```shell
leo run deal_the_hand 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 6u8.private,
  _nonce: 3187378664838095371413816402520861035009492614579850711233114485947770291789group.public
}" aleo14lrrqg3lt088jdtdncpxrjxccy7pf8heq7svejwz3lc0vq7lvy8sstn9xd
```

**Output**

```shell
➡️  Outputs

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 7u8.private,
  _nonce: 2590295634101411185997828821806316244500682235679127296127643852172193812116group.public
}
 • {
  owner: aleo14lrrqg3lt088jdtdncpxrjxccy7pf8heq7svejwz3lc0vq7lvy8sstn9xd.private,
  round: 0u32.private,
  id: 3u64.private,
  _nonce: 2977967796488917373123125134827516983096833814966097401284511780585675426214group.public
}
```

Player2's second hole card is 3, which is J of ♠️.

##### Player3's second hole card

**Run**

```shell
leo run deal_the_hand 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 7u8.private,
  _nonce: 2590295634101411185997828821806316244500682235679127296127643852172193812116group.public
}" aleo1d0mwekavg4yz3qe53h9ed9pgc62yg62dggvtkqhsud23av35cq8qzaca2e
```

**Output**

```shell
➡️  Outputs

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 8u8.private,
  _nonce: 6554850687270293382214991531215420391436779126561108946217344879661061762389group.public
}
 • {
  owner: aleo1d0mwekavg4yz3qe53h9ed9pgc62yg62dggvtkqhsud23av35cq8qzaca2e.private,
  round: 0u32.private,
  id: 11u64.private,
  _nonce: 7263261439963156343729295022594861023720371902557983890474148319787884926546group.public
}
```

Player3's second hole card is 11, which is 3 of ♠️.

Now four players have their hole cards:

* Player0: 5 of ♦️, 4 of ♥️

* PLayer1: 10 of ♦️, 10 of ♠️

* Player2: 5 of ♠️, J of ♠️

* Player3: A of ♥️, 3 of ♠️

Now it's time to flop.

### 6. Flop

We need 3 flop cards, so the dealer need to do flop 3 times.

* First flop:

**Run**

```shell
leo run flop 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 8u8.private,
  _nonce: 6554850687270293382214991531215420391436779126561108946217344879661061762389group.public
}"
```

**Output**

```shell
➡️  Output

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 9u8.private,
  _nonce: 2025628272252496669197541370092468617263845618577861466827315773719971951805group.public
}
```

* Second flop:

**Run**

```shell
leo run flop 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 9u8.private,
  _nonce: 2025628272252496669197541370092468617263845618577861466827315773719971951805group.public
}"
```

**Output**

```shell
➡️  Output

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 10u8.private,
  _nonce: 6779208076879561720672386282916579865431637704975941044326508011527877737946group.public
}
```

* Third flop:

**Run**

```shell
leo run flop 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 10u8.private,
  _nonce: 6779208076879561720672386282916579865431637704975941044326508011527877737946group.public
}"
```

**Output**

```shell
➡️  Output

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 11u8.private,
  _nonce: 151858950085776041772830314238133327594731683409551574781242529437262787659group.public
}
```

As we said above, one u64 represent 8 cards, so after 8 hole cards, the dealer flop within cards1 in Record CardList. Since the dealer can see the cards, for convenience, we deserialize the cards1. (You can also use the [Get Mapping Value](https://developer.aleo.org/testnet/public_endpoints/get_mapping_value) to get the public mapping states).

We can see the flop are:

* 40, which is K of ♦️

* 8, which is 6 of ♠️

* 5, which is 9 of ♠️

### 7. Turn

Now the dealer need to turn.

**Run**

```shell
leo run turn 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 11u8.private,
  _nonce: 151858950085776041772830314238133327594731683409551574781242529437262787659group.public
}"
```

**Output**

```shell
➡️  Output

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 12u8.private,
  _nonce: 3445569138171182483695668145650887750300594328150720831128556558882904104297group.public
}
```

Same as flop step, we can see the turn is:

* 20, which is 7 of ♥️

### 8. River

Now the dealer need to river.

**Run**

```shell
leo run river 0u32 "{
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 12u8.private,
  _nonce: 3445569138171182483695668145650887750300594328150720831128556558882904104297group.public
}"
```

**Output**

```shell
➡️  Output

 • {
  owner: aleo1tntmjcv55ezyqzk5mxc9s5x98uflu3ygsv3z2zq6jmnxz0gewsxs9esa8h.private,
  cards0: 3470877889644462859u64.private,
  cards1: 2884561145227710235u64.private,
  cards2: 1380120365773234201u64.private,
  cards3: 1737271386839589634u64.private,
  cards4: 2377924947429303598u64.private,
  cards5: 1228951828134768418u64.private,
  cards6: 75477204049330176u64.private,
  position: 13u8.private,
  _nonce: 1026832245790025110339627617214380119953864759636766882005876993179324054766group.public
}
```

Same as flop step, the river is:

* 26, which is A of ♣️.

In summary, the 5 community cards are:

* K of ♦️

* 6 of ♠️

* 9 of ♠️

* 7 of ♥️

* A of ♣️

Now the 5 community cards are revealed, players knows 5 community cards and 2 hole cards, he need to showdown, make his hole cards public to others to compare. 

### 9. Showdown

#### Player0 showdown

Player0 use his two hole cards to showdown.

Set the .env private key to the player0.

```json
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpEh5pce3a9rZ1DbZF1BZCr2tNHZmDM7cJsYTsdppSgaWK
```

**Run**

```shell
leo run showdown 0u32 "{
  owner: aleo1xjyvhfdeuwt7q84tlq2vdvrlrkpvaksu96hz8enlzy7nthmq4vxssef92k.private,
  round: 0u32.private,
  id: 48u64.private,
  _nonce: 6378733323186963231481352064100909218505757489494731107078768139531991516446group.public
}" "{
  owner: aleo1xjyvhfdeuwt7q84tlq2vdvrlrkpvaksu96hz8enlzy7nthmq4vxssef92k.private,
  round: 0u32.private,
  id: 23u64.private,
  _nonce: 4156991754494796320626407581079088923218893692388759117059226818326041093842group.public
}"
```

Player0's hole cards are public!

#### Player1 showdown

Player1 use his two hole cards to showdown.

Set the .env private key to the player1.

```json
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp3V4DMmPy4WtXck35wYFNr6vBUqsuZyVP1vrodbxNWbGj
```

**Run**

```shell
leo run showdown 0u32 "{
  owner: aleo1wug20mqdxtkwqwnw4qjzyfna843d8mt77mcgpf2dfv48luduzq9sw4vpxr.private,
  round: 0u32.private,
  id: 43u64.private,
  _nonce: 3157914141585982533317297797722808129268386513182953090292238683972721688591group.public
}" "{
  owner: aleo1wug20mqdxtkwqwnw4qjzyfna843d8mt77mcgpf2dfv48luduzq9sw4vpxr.private,
  round: 0u32.private,
  id: 4u64.private,
  _nonce: 830764277915085358430578601770062189530737248156740656831334617808385044350group.public
}"
```

Player1's hole cards are public!

#### Player2 showdown

Player2 use his two hole cards to showdown.

Set the .env private key to the player2.

```json
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp5f4MhHDvdbia2qqHL1ALg2pA52XQtpPZASkC3y59dHvg
```

**Run**

```shell
leo run showdown 0u32 "{
  owner: aleo14lrrqg3lt088jdtdncpxrjxccy7pf8heq7svejwz3lc0vq7lvy8sstn9xd.private,
  round: 0u32.private,
  id: 9u64.private,
  _nonce: 4986689982864217550308627758492387771386739735916949589669725252594466626262group.public
}" "{
  owner: aleo14lrrqg3lt088jdtdncpxrjxccy7pf8heq7svejwz3lc0vq7lvy8sstn9xd.private,
  round: 0u32.private,
  id: 3u64.private,
  _nonce: 2977967796488917373123125134827516983096833814966097401284511780585675426214group.public
}"
```

Player2's hole cards are public!

#### Player3 showdown

Player3 use his two hole cards to showdown.

Set the .env private key to the player3.

```json
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp7kFCLEoro6VE3JNybKoMbpkeyL49Nz9fWBqMyNfTnNoA
```

**Run**

```shell
leo run showdown 0u32 "{
  owner: aleo1d0mwekavg4yz3qe53h9ed9pgc62yg62dggvtkqhsud23av35cq8qzaca2e.private,
  round: 0u32.private,
  id: 13u64.private,
  _nonce: 550190331851291490782453786647988716049414816386351260460997247271250108554group.public
}" "{
  owner: aleo1d0mwekavg4yz3qe53h9ed9pgc62yg62dggvtkqhsud23av35cq8qzaca2e.private,
  round: 0u32.private,
  id: 11u64.private,
  _nonce: 7263261439963156343729295022594861023720371902557983890474148319787884926546group.public
}"
```

Player3's hole cards are public!

### 10. Win

Now all the player's hole cards and community cards are public, the dealer can determine who is the winner!

Let's do the summary:

- Player0: 5 of ♦️, 4 of ♥️

- PLayer1: 10 of ♦️, 10 of ♠️

- Player2: 5 of ♠️, J of ♠️

- Player3: A of ♥️, 3 of ♠️

- 3 flops: K of ♦️, 6 of ♠️, 9 of ♠️

- turn: 7 of ♥️

- river: A of ♣️

So the winner is Player3, he get double Ace! Player2 is so close to get Straight Flush!

Set the .env private key to the dealer.

```json
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpG1uH9TvrNuT59QcwxTTy9LMNusarvxgYRNUoqW9KZxXV
```

**Run**

```shell
leo run win 0u32 aleo1d0mwekavg4yz3qe53h9ed9pgc62yg62dggvtkqhsud23av35cq8qzaca2e
```

## Deployment

```shell
✅ Successfully broadcast deployment at1pffpv7ehguzvp89kt92xve7lx98y7tzrxcdvpxgqkpch0cq7lyxs9kzajp ('texas_hold_em_123456789.aleo') to https://vm.aleo.org/api/testnet3/transaction/broadcast.
at1pffpv7ehguzvp89kt92xve7lx98y7tzrxcdvpxgqkpch0cq7lyxs9kzajp
```

📚Tricks

There are 3 parts fee: storage fee, namespace fee, priority fee.

* Storage fee, every byte cost 1000 microcredits.

* Namespace fee, the algorithm is: `10^(10 - num_characters)`, this means the shorter the name, the more it costs. If the program name has 10 characters, then it only cost minimal fee. In our program, we define a very long name.

* Priority fee, you can just set it as 0 to save the fee.

## Future work

1. Add credits transfer/stake in the game (like a real Texas Hold'em)
2. Replace the cards bit representation if Leo's array feature is ready (It may save a lot of constraints and code!)
3. Maybe a UI? like a real dapp.
