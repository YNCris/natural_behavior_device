function cos_sim = cossim(x,y)

cos_sim = dot(x, y) / (norm(x) * norm(y));