# BE STRONGER V25 — Accès séparés

## Espace coach
URL locale : `coach.html`

Compte de démonstration hors ligne :
- Email : `coach@bestronger.app`
- Mot de passe : `BScoach2026!`

⚠️ Ces identifiants sont uniquement pour la démo locale. Pour la production, créer ton compte coach dans Supabase Auth et ne jamais stocker un vrai mot de passe dans le code.

## Codes clients de démonstration
- BS-JONATHAN-001
- BS-JONATHAN-002
- BS-JONATHAN-003

Un vrai système de production utilise `coach_invite_codes` et consomme chaque code une seule fois.

## Séparation
- `index.html` = application client
- `coach.html` = espace coach
- aucun bouton « Espace Coach » dans l'interface client
- les deux entrées doivent être protégées côté serveur avec Supabase Auth + RLS.
