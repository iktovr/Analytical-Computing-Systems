[x, y, z] = ndgrid(-10:0.1:10, -10:0.1:10, -10:0.1:10);

u = 7*x.^2 + 8*x.*y + 3*y.^2 + 8*x.*z + 6*y.*z + 3*z.^2 + 6*x + y + 7;

A = [
    7, 4, 4;
    4, 3, 3;
    4, 3, 3
];
B = [3; 0.5; 0];
a0 = 7;

% Характеристический многочлен
char_poly = poly(A);
polyout(char_poly, 'x')

% Собственные значения
eigenvalues = sort(roots(char_poly))
n = size(eigenvalues, 1);

% Собственные векторы
eigenvectors = [];
for i = 1:n
  % находим как ядро соответствующего линейного отображения
  eigenvectors = cat(2, eigenvectors, null(A - eye(n) * eigenvalues(i,1)));
endfor
eigenvectors

% Проверка собственных значений и векторов
[vectors, values] = eig(A);
% Сравнивать будем с точностью до эпсилон
eps = 1e-10;
if (eigenvalues - diag(values) < eps)
  printf("Eigenvalues are equal\n");
endif
for i = 1:n
  if (eigenvectors(:,i) - vectors(:,i) < eps)
    printf("Eigenvectors %d are equal\n", i);
  endif 
endfor

% Матрица перехода
S = eigenvectors
% Дополнительная нормировка не нужна, null возращает нормированый вектор
% S = [];
% for i = 1:n
%   S = cat(2, S, eigenvectors(:,i)./sqrt(dot(eigenvectors(:,i), eigenvectors(:,i))));
% endfor

% Диагональная матрица
A1 = S' * A * S
% Преобразование коэффициентов линейной формы
B1 = S' * B

% Почти приведенное уравнение (приводить дальше не имеет смысла)
variables = cat(4, x, y, z); % объединяем трехмерные матрицы по 4 измерению
v = a0;
for i = 1:n
  v += A1(i, i) * variables(:,:,:,i) .^ 2 + 2 * B1(i, 1) * variables(:,:,:,i);
endfor
v /= a0;

figure();
isosurface(u, 0);

figure();
isosurface(v, 0);
