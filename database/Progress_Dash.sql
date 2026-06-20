USE gyan_setu;

CREATE OR REPLACE VIEW progress_dashboard AS
SELECT 
    c.child_id,
    c.username AS child_name,
    p.parent_id,
    p.full_name AS parent_name,
    c.total_points,
    c.current_level,
    COUNT(DISTINCT cb.coin_id) AS coin_earned,
    AVG(cp.quiz_score) AS average_quiz_score,
    COUNT(CASE WHEN cp.status = 'completed' THEN 1 END) AS lessons_completed,
    (SELECT SUM(ps.points_spent) FROM purchases ps WHERE ps.child_id = c.child_id) AS total_points_spent
FROM children c
JOIN parents p ON c.parent_id = p.parent_id
LEFT JOIN child_coin cb ON c.child_id = cb.child_id
LEFT JOIN child_progress cp ON c.child_id = cp.child_id
GROUP BY c.child_id;