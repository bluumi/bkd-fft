function [r] = add_mask_to_image(f, m)

f = f - min(min(min(f)));
f = f / max(max(max(f)));

m = m - min(min(min(m)));
m = m / max(max(max(m)));

r = [repmat([m; zeros(size(f,1)-size(m,1), size(m,2))], [1,1,size(f,3)]), f];