# ESPHome — routeur solaire off-grid `offsr` (batterie 24 V ou 48 V)

Ce dossier est **prêt à compiler** : il contient le composant `offsr` de SeByDocKy déjà patché
(flag 24 V / 48 V) et un YAML complet autonome (sans Home Assistant).

```
esphome/
├── offroutsr-24-48v-standalone.yaml   # YAML complet du routeur
└── components/
    └── offsr/                         # composant de Seby (commit 12fb7b5) + patch 24/48 V
```

Le composant est identique, octet pour octet, à `SeByDocKy/myESPhome` au commit `12fb7b5` (25/10/2026)
auquel on applique `../patches/offsr-24-48v.patch`. Il inclut le sélecteur `coeff_multiplier` ajouté par Seby le jour même.

## Principe

L'ESP32 règle une charge résistive (radiateur, ballon) pour qu'elle absorbe **l'excédent solaire** et que le courant
de batterie reste proche d'une consigne :

```
SmartShunt (BLE) ─► ESP32 / offsr ─► DAC GP8403 (0-10 V) ─► régulateur à angle de phase LSA ─► charge 230 V
                          ▲                                                 │
                          └────────── PZEM-004T (puissance réelle) ◄────────┘
```

- Le SmartShunt Victron fournit tension et courant batterie (lecture Bluetooth, aucun fil).
- Le PZEM ne corrige pas la régulation : il sert à détecter une coupure du thermostat de la charge (`thermostat_cut`).

## Matériel testé

| Élément | Référence | Remarque |
|---|---|---|
| ESP32 | DevKit `esp32dev` | |
| DAC | DFRobot Gravity GP8403 / GP8413 | adresse I2C **0x5F** sur mon module (pas 0x58) ; SDA GPIO22, SCL GPIO21 |
| Régulateur | Loncont LSA-H3P40YB | commande 0-10 V, angle de phase |
| Mesure puissance | PZEM-004T V4.0 100 A + tore | UART : ESP TX GPIO19 → RX PZEM, ESP RX GPIO18 ← TX PZEM, 9600 bauds, 2 bits de stop |
| Batterie | Victron SmartShunt | lu en Bluetooth (`esphome-victron_ble`) |
| Écran | OLED 0,96" 128×64 I2C, marquage **JMD0.96C** (contrôleur SSD1306 probable) | adresse `0x3C`, même bus I2C que le GP8403 (SDA GPIO22, SCL GPIO21), alimenté en 3V3 |
| Dissipateur | aluminium **110 × 75 mm** | porte le LSA ; sort par une lucarne du couvercle |

Câblage du PZEM : le 220 V sur ses bornes L/N, la liaison TTL en plus, et **le 5 V du connecteur TTL doit être relié**
(sans lui : octets aléatoires puis timeouts). Il se place côté entrée du LSA, avant le découpage.

## Installation

1. Copie le dossier `esphome/` dans ta configuration ESPHome (ou seulement `components/offsr/` à côté de ton YAML).
2. Remplis les `substitutions:` en tête du YAML (il n'y a ni `secrets.yaml` ni `!secret`) : `wifi_ssid`, `wifi_password`,
   `ap_password`, `adress_ip`, `gateway_ip`, `dns_ip`, `smartshunt_mac`, `smartshunt_bindkey` (MAC et clé de liaison à lire
   dans VictronConnect), ainsi que `battery_nominal`, `sensor_prefix` et le nom.
3. Mets tes coordonnées dans `sun:` (utile seulement si tu t'en sers dans des automatisations).
4. Compile et flashe. Version ESPHome testée : 2026.9.1.

**Sécurité réseau :** ce YAML n'active ni chiffrement de l'API ni mot de passe OTA, pour un routeur sur un réseau privé
de confiance (et sans Home Assistant). Si l'ESP32 est sur un réseau partagé, ajoute `api: encryption:` et un mot de passe OTA.

## Écran OLED

Écran 0,96" 128×64 en I2C (marquage `JMD0.96C`), branché en parallèle du GP8403 : VCC sur 3V3, GND, SDA GPIO22, SCL GPIO21.
Réglages en tête du YAML : `oled_address` (`"0x3C"`), `oled_model` (`"SSD1306 128x64"`, ou `"SH1106 128x64"` si l'image est
décalée ou bruitée sur les bords) et `i2c_frequency` (`"400kHz"`) et `oled_rotation` (`"180°"` ; `"0°"` pour l'orientation normale). Le scan I2C du journal doit afficher `0x3C` et `0x5F`.

Quatre lignes, rafraîchies chaque seconde :

1. **état** : `DESACTIVE`, `MANUEL`, `SHUNT ABSENT`, `BATTERIE BASSE` (tension sous `starting`), `THERMOSTAT COUPE`,
   `ROUTAGE ACTIF` (puissance mesurée ≥ 5 W) ou `VEILLE` ;
2. **sortie** en % (valeur envoyée au LSA : elle vaut `output_min` au repos, sans que la charge chauffe) ;
3. **puissance** mesurée par le PZEM, en W ;
4. **tension et courant** de la batterie.

La police est téléchargée à la compilation (`gfonts://`) : il faut un accès internet sur la machine qui compile.

## Flag 24 V / 48 V

```yaml
substitutions:
  battery_nominal: "24"      # "24" ou "48"
```

| `battery_nominal` | seuil `starting` | seuil `charged` | seuil `discharged` |
|---|---|---|---|
| `48` (défaut du composant) | 53,0 V | 55,8 V | 55,6 V |
| `24` | 27,0 V | 28,0 V | 27,6 V |

- Le flag ne règle que les valeurs **par défaut**. Si l'ESP a déjà sauvegardé ces seuils en flash (premier démarrage,
  ou réglage fait dans l'interface web), la valeur sauvegardée garde la priorité : après un changement de flag,
  ressaisis les trois seuils une fois dans l'interface web.
- Les curseurs couvrent 20 à 64 V.
- Les valeurs 24 V sont des points de départ prudents pour un gel, pas des valeurs validées : `charged` doit être
  la tension d'absorption de ton chargeur moins environ 0,2 V, et `starting` doit se placer au-dessus de la tension
  d'une batterie pleine au repos (~25,8 V). Mesure ton pack avant de t'y fier.

## Logique de régulation (à connaître avant de régler)

- **Cible de courant** selon la tension : sous `discharged` → `charging_setpoint` ; entre `discharged` et `charged`
  → `absorbing_setpoint` ; au-dessus de `charged` → `floating_setpoint`. Sous `starting`, la sortie est à 0.
- **`pid_mode` OFF (conseillé)** : la sortie s'incrémente à chaque cycle (sortie précédente + P + I + D).
  En **ON**, la sortie vaut seulement P + I + D ; avec les coefficients internes (0,001 / 0,0001 / 0,001) elle reste
  collée à `output_min` : la puissance ne monte pas.
- **`floating_setpoint`** : en dessous de 0 A, le routeur accepte de tirer du courant sur la batterie. Un petit
  positif (0,2 A sur mon banc) évite de décharger la batterie en régime établi.
- **`output_min`** : fraction de sortie en dessous de laquelle la charge ne conduit pas (zone morte du LSA et de la
  charge) ; à mesurer. `output_max` plafonne la puissance.
- **`thermostat_cut`** : si la puissance mesurée tombe sous 2 W alors que la sortie était au-dessus de `output_restart`,
  le routeur considère que le thermostat de la charge a coupé, ramène la sortie à `output_restart` et reprend la
  régulation quand la charge revient.
- **Intégrale** : elle s'accumule sans limite et n'est remise à zéro qu'au redémarrage. Surveille les montées brutales
  après une longue période sans soleil.

Valeurs relevées sur mon banc (radiateur bain d'huile 850 W, pack gel 24 V) : `pid_mode` OFF, `kp` 0,2, `ki` 0,2,
`kd` 0,3, `output_max` 0,85, `output_restart` 0,40, `floating_setpoint` 0,2 A. À adapter, rien de tout cela n'est universel.

## `coeff_multiplier`

Sélecteur ajouté par Seby : 10 / 1 / 0,1 / 0,01 (défaut 1). Il multiplie ensemble `kp`, `ki` et `kd` pour adapter
la plage des gains à la vitesse de la boucle. Un multiplicateur de 10 rend la montée dix fois plus rapide : à essayer
par petits pas, surtout sur une batterie ou un onduleur fragiles (un pas de puissance trop brusque peut provoquer
des appels de courant).

## Commande manuelle de la puissance

`manual_override` ne force pas une marche : il gèle la régulation (offsr n'écrit plus la sortie). Pour piloter la
puissance à la main, le YAML déclare un `fan` (curseur `manual_power`, 0-100 %) branché sur la même sortie.

1. `manual_override` ON, `activation` ON.
2. Règle le curseur `manual_power`.
3. Retour en auto : curseur à 0, puis `manual_override` OFF.

En manuel, plus aucune protection batterie n'agit. N'utilise pas le curseur hors `manual_override` : deux écritures
sur la même sortie.

## Mettre à jour le composant

Si Seby publie une nouvelle version de `offsr`, depuis la racine du dépôt :

```bash
UPSTREAM_REF=main ./apply.sh      # clone Seby, applique le patch, résultat dans build/components/offsr
```

Si le patch ne s'applique plus, `offsr` a changé en amont : il faut rebaser le patch.

## Provenance et licence

Le composant `offsr` est l'œuvre de [SeByDocKy](https://github.com/SeByDocKy/myESPhome) (extrait du projet pvbrain2).
Sa copie ici est celle du commit `12fb7b5`, plus le patch de ce dépôt. Le dépôt amont est sous licence MIT
(Copyright (c) 2026 e-2-nomy) : le texte est conservé dans `components/offsr/LICENSE`. Le reste du dépôt (patch, YAML,
documentation, boîtier) est sous MIT, Copyright (c) 2026 PFU (voir `../LICENSE`).
