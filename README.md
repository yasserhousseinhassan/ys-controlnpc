# YS-CONTROLNPC

> **Premium NPC & Traffic Control System for FiveM**
> Developed by **Yasser Storm Development**

---

## Description

**ys-controlnpc** est une ressource FiveM premium qui offre un contrôle complet et dynamique de la population du monde GTA V. Gérez les PNJ, le trafic, les scénarios et les événements en temps réel via une interface OX Lib élégante — sans aucun redémarrage requis.

---

## Fonctionnalités

| Module | Description |
|---|---|
| **Gestion des PNJ** | Activation/désactivation/densité des piétons |
| **Gestion du Trafic** | Contrôle du trafic routier et des véhicules garés |
| **Scénarios GTA V** | Contrôle par catégorie (police, ambulance, etc.) |
| **Événements Aléatoires** | Toggle des événements aléatoires du mode solo |
| **Contrôle des Densités** | Sliders de densité de 0% à 100% par paliers de 10% |
| **Presets Rapides** | Performance, Roleplay, Semi-RP, Vanilla, Custom |
| **Statistiques Temps Réel** | Compteurs, densités, FPS estimés gagnés |
| **Paramètres Avancés** | Sauvegarde, réinitialisation, phares distants |

---

## Dépendances

- [ox_lib](https://github.com/overextended/ox_lib)

---

## Installation

1. Télécharger et placer `ys-controlnpc` dans votre dossier `resources/`
2. Ajouter `ensure ox_lib` avant `ensure ys-controlnpc` dans votre `server.cfg`
3. Ajouter `ensure ys-controlnpc` dans votre `server.cfg`
4. Configurer les permissions ACE (voir ci-dessous)
5. Redémarrer le serveur

---

## Permissions ACE

Ajoutez ces lignes à votre `server.cfg` :

```cfg
# Donner accès au groupe admin
add_ace group.admin ys.controlnpc allow

# Ou pour un joueur spécifique
add_ace identifier.license:XXXXXXXXXXXXXX ys.controlnpc allow
```

> **Note :** Vous pouvez désactiver la restriction ACE en modifiant `Config.Permission.restrictToAce = false` dans `config.lua`.

---

## Commandes & Raccourcis

| Commande / Touche | Action |
|---|---|
| `/npcmenu` | Ouvre le menu principal |
| `/controlnpc` | Ouvre le menu principal (alias) |
| `F5` | Raccourci clavier (configurable) |

---

## Presets

| Preset | PNJ | Trafic | Scénarios | Événements |
|---|---|---|---|---|
| **Performance** | 0% | 0% | Non | Non |
| **Roleplay** | 25% | 25% | Oui | Non |
| **Semi-RP** | 50% | 50% | Oui | Oui |
| **Vanilla GTA** | 100% | 100% | Oui | Oui |
| **Custom** | Configurable | Configurable | Configurable | Configurable |

---

## Structure du Projet

```
ys-controlnpc/
├── fxmanifest.lua          # Manifest FiveM
├── config.lua              # Configuration complète
├── client/
│   ├── main.lua            # Logique client principale
│   ├── menu.lua            # Interface OX Lib
│   ├── density.lua         # Contrôle des densités
│   └── scenarios.lua       # Gestion des scénarios
├── server/
│   ├── main.lua            # Logique serveur principale
│   ├── permissions.lua     # Système ACE
│   └── save.lua            # Sauvegarde JSON
├── data/
│   └── settings.json       # Fichier de sauvegarde
└── README.md
```

---

## Compatibilité

- Standalone
- ESX
- QBCore
- OneSync Infinity
- 128+ joueurs
- 256+ joueurs

---

## Performance

- **Consommation :** ~0.00 ms au repos
- **Thread unique** pour les densités (optimisé)
- **Pas de thread** pour les scénarios (application unique à chaque changement)
- **Pas de polling inutile**

---

## Logs Console

Les actions sont loguées avec le préfixe `[YS-CONTROLNPC]` :

```
[YS-CONTROLNPC] Resource started — Yasser Storm Development
[YS-CONTROLNPC] State updated — PNJ: 25% | Trafic: 25% — by AdminName
[YS-CONTROLNPC] All scenarios disabled
[YS-CONTROLNPC] Mode Performance chargé
[YS-CONTROLNPC] Settings saved on resource stop
```

---

## Sauvegarde

Les paramètres sont automatiquement sauvegardés dans `data/settings.json` et restaurés :

- Après reconnexion d'un joueur
- Après redémarrage de la ressource
- Après redémarrage du serveur

---

## Licence

© 2024 **Yasser Storm Development** — Tous droits réservés.
Ce script est protégé et ne peut être redistribué sans autorisation.

---

<p align="center">
  <b>Yasser Storm Development</b><br>
  Premium FiveM Resources
</p>
