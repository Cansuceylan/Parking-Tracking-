% Demo to find available parking spaces.
% Mevcut park yerlerini bulmak için Demo.
% Requires 3 images: 'Parking Lot without Cars.jpg', 'Parking Lot with Cars.jpg', 'Parking Lot Mask.png'
% 3 resim gerektirir: 'Arabasız Park Yeri.jpg', 'Arabalı Park Yeri.jpg', 'Otopark Maskesi.png'

clc;    % Clear the command window. % Komut penceresini temizleyin.
close all;  % Close all figures (except those of imtool.) /% Tüm rakamları kapatın (imtool hariç)
clearvars;  % Clear variables from memory / Bellekten değişkenleri temizle
workspace;  % Make sure the workspace panel is showing. / % Çalışma alanı panelinin gösterildiğinden emin olun.
format long g; % Set Command Window output display format/ Komut Penceresi çıktı görüntüleme formatını ayarla
format compact;
fontSize = 14;
fprintf('Beginning to run %s.m ...\n', mfilename);

%-----------------------------------------------------------------------------------------------------------------------------------
% Read in reference image with no cars (empty parking lot).
% Araçsız referans görüntüde okuyun (boş park yeri).

folder = pwd; % Geçerli klasörü yerel bir klasöre değiştirin ve yolu kaydedin.
baseFileName = 'Parking Lot without Cars.jpg';
fullFileName = fullfile(folder, baseFileName);
% Check if file exists./ % Dosyanın var olup olmadığını kontrol edin.
if ~exist(fullFileName, 'file')
	% The file doesn't exist -- didn't find it there in that folder.
    % Dosya mevcut değil - orada o klasörde bulamadı.
    
	% Check the entire search path (other folders) for the file by stripping off the folder.
    % Klasörü çıkararak dosyanın tüm arama yolunu (diğer klasörler) kontrol edin.
    
	fullFileNameOnSearchPath = baseFileName; % No path this time./Bu sefer yol yok.
	if ~exist(fullFileNameOnSearchPath, 'file')
		% Still didn't find it.  Alert user.
        % Yine de bulamadı. Kullanıcıyı uyarın.
		errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
rgbEmptyImage = imread(fullFileName);
[rows, columns, numberOfColorChannels] = size(rgbEmptyImage);
% Display the test image full size./% Test görüntüsünü tam boyutta görüntüleyin.
subplot(2, 3, 2);
imshow(rgbEmptyImage, []);
axis('on', 'image');
caption = sprintf('Reference Image : "%s"', baseFileName);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); %Pixel Information tool / Piksel Bilgileri aracı
% Set up status line to see values when you mouse over the image.
% Fareyi görüntünün üzerine getirdiğinizde değerleri görmek için durum satırını ayarlayın.

%-----------------------------------------------------------------------------------------------------------------------------------
% Read in test image (image with cars parked on the parking lot).
% Test görüntüsünü okuyun (otoparka park edilmiş araçların bulunduğu görüntü).

folder = pwd;
baseFileName = 'PARKİNGALLL.jpeg';
fullFileName = fullfile(folder, baseFileName);
% Check if file exists./% Dosyanın var olup olmadığını kontrol edin.
if ~exist(fullFileName, 'file')
	% The file doesn't exist -- didn't find it there in that folder.
    % Dosya mevcut değil - orada o klasörde bulamadı.
	% Check the entire search path (other folders) for the file by stripping off the folder.
    % Klasörü çıkararak dosyanın tüm arama yolunu (diğer klasörler) kontrol edin.
    
	fullFileNameOnSearchPath = baseFileName; % No path this time./ Bu sefer yol yok.
	if ~exist(fullFileNameOnSearchPath, 'file')
		% Still didn't find it.  Alert user./ Yine de bulamadı. Kullanıcıyı uyarın.
		errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
rgbTestImage = imread(fullFileName);
[rows, columns, numberOfColorChannels] = size(rgbTestImage);
% Display the original image full size./% Orijinal görüntüyü tam boyutta görüntüleyin.
subplot(2, 3, 1);
imshow(rgbTestImage, []);
axis('on', 'image');
caption = sprintf('Test Image : "%s"', baseFileName);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Fareyi görüntünün üzerine getirdiğinizde değerleri görmek için durum satırını ayarlayın.
% Set up figure properties:/% Şekil özelliklerini ayarlayın:
% Enlarge figure to full screen./% Rakamı tam ekrana büyüt.
hFig1 = gcf; % Current figure handle
hFig1.Units = 'Normalized';
hFig1.WindowState = 'maximized';
% Get rid of tool bar and pulldown menus that are along top of figure.
% set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.

% Şeklin üst kısmındaki araç çubuğu ve açılır menülerden kurtulun.
% set (gcf, 'Araç Çubuğu', 'yok', 'Menü', 'yok');
% Başlık çubuğuna bir isim verin.

hFig1.Name = 'Demo by Image Analyst';

%-----------------------------------------------------------------------------------------------------------------------------------
% Read in mask image that defines where the spaces are./% Boşlukların nerede olduğunu tanımlayan maske görüntüsünü okuyun.
folder = pwd;
baseFileName = 'Parking Lot Mask.png';
fullFileName = fullfile(folder, baseFileName);
% Check if file exists.% Dosyanın var olup olmadığını kontrol edin.
if ~exist(fullFileName, 'file')
	% The file doesn't exist -- didn't find it there in that folder.
    % Dosya mevcut değil - orada o klasörde bulamadı.
	% Check the entire search path (other folders) for the file by stripping off the folder.
    % Klasörü çıkararak dosyanın tüm arama yolunu (diğer klasörler) kontrol edin.
	fullFileNameOnSearchPath = baseFileName; % No path this time.
	if ~exist(fullFileNameOnSearchPath, 'file')
		% Still didn't find it.  Alert user.
        % Yine de bulamadı. Kullanıcıyı uyarın.
		errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
maskImage = imread(fullFileName);
[rows, columns, numberOfColorChannels] = size(maskImage);
% Create a binary mask from seeing where the min value is 255.
% Minimum değerin 255 nerede olduğunu görerek bir ikili maske oluşturun.
mask = min(maskImage, [], 3) == 255;
% Display the test image full size./% Test görüntüsünü tam boyutta görüntüleyin.
subplot(2, 3, 3);
imshow(mask, []);
axis('on', 'image');
caption = sprintf('Mask Image : "%s"', baseFileName);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Fareyi görüntünün üzerine getirdiğinizde değerleri görmek için durum satırını ayarlayın.

%-----------------------------------------------------------------------------------------------------------------------------------
% Find the cars.
% Arabaları bulun.
% First, get the absolute difference image.
% İlk olarak, mutlak fark görüntüsünü alın.
diffImage = imabsdiff(rgbEmptyImage, rgbTestImage); %Absolute difference of two images
% Display the gray scale image.
% Gri tonlamalı resmi görüntüleyin.
subplot(2, 3, 4);
imshow(diffImage, []);
axis('on', 'image');
caption = sprintf('Difference Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Fareyi görüntünün üzerine getirdiğinizde değerleri görmek için durum satırını ayarlayın.
% Convert to gray scale and mask it with the spaces mask.
% Gri ölçeğe dönüştürün ve boşluk maskesi ile maskeleyin.
diffImage = rgb2gray(diffImage);
diffImage(~mask) = 0; %
% Get a histogram of the image so we can see where to threshold it at.
% Görüntünün histogramını alın, böylece onu nerede eşleştireceğimizi görebiliriz.
subplot(2, 3, 5);
histogram(diffImage(diffImage>0));
% Display the gray scale image.
% Gri tonlamalı resmi görüntüleyin.
imshow(diffImage, []);
axis('on', 'image');
caption = sprintf('Gray Scale Difference Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Fareyi görüntünün üzerine getirdiğinizde değerleri görmek için durum satırını ayarlayın.
% Threshold the image to find pixels that are substantially different from the background.
% Arka plandan büyük ölçüde farklı pikselleri bulmak için görüntüyü eşikleyin.
kThreshold = 50; % Determined by examining the histogram.% Histogram incelenerek belirlenir.
parkedCars = diffImage > kThreshold;
% Fill holes.% Delikleri doldurun.
parkedCars = imfill(parkedCars, 'holes');% Get convex hull.%Görüntü bölgelerini ve delikleri doldurun
parkedCars = bwconvhull(parkedCars, 'objects');% Dışbükey gövde alın.
% Display the mask image.% Maske görüntüsünü görüntüleyin.
subplot(2, 3, 6);
imshow(parkedCars, []);
impixelinfo;
axis('on', 'image');
caption = sprintf('Parked Cars Binary Image with Threshold = %.1f', kThreshold);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;

%-----------------------------------------------------------------------------------------------------------------------------------
% Measure the percentage of white pixels within each rectangular mask.
% Her bir dikdörtgen maske içindeki beyaz piksellerin yüzdesini ölçün.
props = regionprops(mask, parkedCars, 'MeanIntensity', 'Centroid', 'BoundingBox');
centroids = vertcat(props.Centroid); %Dizileri dikey olarak birleştir

%-----------------------------------------------------------------------------------------------------------------------------------
% Optional sorting by row with kmeans.  Only appropriate for parking lot with rectangular grid aligned with image edges.
% Kmeans ile satıra göre isteğe bağlı sıralama. Yalnızca görüntü kenarlarıyla hizalanmış dikdörtgen ızgaralı park yeri için uygundur.
% Sort y centroids 
% Y centroidleri sırala
numRows = 4; % There are 4 rows in the parking lot to park in.
% Otoparkta park edilecek 4 sıra bulunmaktadır.
[indexesY, clusterCenterY] = kmeans(centroids(:, 2), numRows);
% Put lines across at the y centroids of the spaces in the mask rows.
% Çizgileri, maske sıralarındaki boşlukların ağırlık merkezlerine koyun.
for k = 1 : numRows
	yline(clusterCenterY(k), 'Color', 'm', 'LineWidth', 4);
end
% Put cyan bounding boxes for each space (whether taken or available).
% Her boşluk için sarı sınırlayıcı kutular koyun (ister alınmış ister mevcut olsun).
for k = 1 : length(props)
	rectangle('Position', props(k).BoundingBox, 'EdgeColor', 'c');
end
% Now the clusters are not necessarily sorted with cluster 1 at the top, cluster 2 right below it, cluster 3 below that, and cluster 4 at the bottom.
% Şimdi, kümelerin üstte küme 1, hemen altında küme 2, bunun altında küme 3 ve altta küme 4 olacak şekilde sıralanması gerekmez.
% So we need to sort the clusters by the y value of the cluster center.
% Yani kümeleri küme merkezinin y değerine göre sıralamamız gerekiyor.
[~, sortOrder] = sort(clusterCenterY, 'ascend');
% Now sort the indexes and we will have them going from top to bottom.
% Şimdi dizinleri sıralayın ve yukarıdan aşağıya gitmelerini sağlayacağız.
originalIndexes = indexesY;
% Save a copy so we can compare to make sure it did it correctly.
% Bir kopyasını kaydedin, böylece doğru yaptığından emin olmak için karşılaştırabiliriz.
fprintf('\nOriginal Class Number    New Class #\n');
for k = 1 : length(indexesY)
	currentClass = indexesY(k);
	newClass = find(sortOrder == currentClass);
	fprintf('                  %d       %d\n', newClass, currentClass);
	indexesY(k) = newClass;
% 	text(centroids(k, 1), centroids(k, 2)-15, num2str(currentClass), 'Color', 'r');
% 	text(centroids(k, 1), centroids(k, 2)+15, num2str(newClass), 'Color', 'g');
end
% comparedLabels = [originalIndexes(:), indexesY(:)];
newLabels = 1 : length(props);
% Look up table so we can map the original index to a new sorted index.
% Orijinal dizini yeni sıralanmış dizine eşleyebilmemiz için tabloya bakın.
pointer = 0;
for k = 1 : numRows
	% For this class (row of parking), get the elements of props that are in this row (y value).
    % Bu sınıf için (park sırası), bu satırda bulunan sahne öğelerini (y değeri) alın.
	thisClass = find(indexesY == k);
	% The x centroid values are already sorted from left to right so we're ok there - no need to sort.
    % X centroid değerleri zaten soldan sağa sıralanmıştır, bu yüzden burada sorun yok - sıralamaya gerek yok.
	newLabels((pointer + 1) : (pointer + length(thisClass))) = thisClass;
	pointer = pointer + length(thisClass);
end
% Now that we have the new sort order, apply it.
% Şimdi yeni sıralama düzenine sahip olduğumuza göre uygulayın.
props = props(newLabels);
% Re-extract these vectors with the new order.
% Bu vektörleri yeni sırayla yeniden çıkarın.
percentageFilled = [props.MeanIntensity]
centroids = vertcat(props.Centroid);
%-----------------------------------------------------------------------------------------------------------------------------------


%-----------------------------------------------------------------------------------------------------------------------------------
% Place a red x on the image if the space is filled, and a green circle if the space is available to be parked on (it's empty).
% Go through each rectangle and say whether it's filled with a car or not.
% We'll say it's filled if 10% of the pixels are filled.

% Alan doluysa görüntünün üzerine kırmızı bir x ve park edilebilecek yer varsa yeşil bir daire yerleştirin (boş).
% Her dikdörtgenin üzerinden geçin ve bir araba ile dolu olup olmadığını söyleyin.
% Piksellerin% 10'u doluysa doldurulduğunu söyleyeceğiz.

hFig2 = figure;
imshow(rgbTestImage);
hFig2.WindowState = 'maximized';
% Give a name to the title bar.
% Başlık çubuğuna bir isim verin.
hFig2.Name = 'Demo by ImageAnalyst';
hold on;
for k = 1 : length(props)
	x = centroids(k, 1);
	y = centroids(k, 2);
	blobLabel = sprintf('%d', k);
	if percentageFilled(k) > 0.14
		% It has a car in that rectangle.
        % Bu dikdörtgende bir araba var.
		plot(x, y, 'rx', 'MarkerSize', 30, 'LineWidth', 4);
		% Put up the blob label.
        % Blob etiketini koyun.
		text(x, y+20, blobLabel, 'Color', 'r', 'FontSize', 15, 'FontWeight', 'bold');
	else
		% No car is parked there.  The space is available.
        % Oraya park edilmiş araba yok. Boş alan mevcuttur.
		plot(x, y, 'g.', 'MarkerSize', 40, 'LineWidth', 4);
		% Put up the blob label.
        % Blob etiketini koyun.
		text(x, y+20, blobLabel, 'Color', 'g', 'FontSize', 15, 'FontWeight', 'bold');
	end
	
end
title('Green = Empty / Red = Full ', 'FontSize', fontSize);
fprintf('Done running %s.m ...\n', mfilename);
