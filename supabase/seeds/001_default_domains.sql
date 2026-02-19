-- ════════════════════════════════════════════════════════════════════════════
-- Seed: Domaines par défaut
-- Description: Insère les 5 domaines de vie par défaut pour chaque profil
--              existant qui n'en a pas encore.
-- Exécuté par: `supabase db reset`
-- ════════════════════════════════════════════════════════════════════════════

INSERT INTO public.domains (user_id, name, icon, color, sort_order)
SELECT p.id, d.name, d.icon, d.color, d.sort_order
FROM public.profiles p
CROSS JOIN (
  VALUES
    ('Santé',                    '💪', '#4CAF50', 0),
    ('Travail',                  '💼', '#2196F3', 1),
    ('Relations',                '❤️', '#E91E63', 2),
    ('Finances',                 '💰', '#FF9800', 3),
    ('Développement personnel',  '🌱', '#9C27B0', 4)
) AS d(name, icon, color, sort_order)
WHERE NOT EXISTS (
  SELECT 1 FROM public.domains dom WHERE dom.user_id = p.id
);
