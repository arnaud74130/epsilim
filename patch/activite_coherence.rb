ex2=Exercice.find(2)
ex2.personnes.each do |personne|
	personne.activites.each do |activite|
		holiday=Date.strptime(activite.jour.to_s,"%j").holiday?(:fr)
		puts "#{Personne.find(activite.personne_id).full_name}" if holiday	
		activite.delete if holiday			
	end
end
# ex2=Exercice.find(2)
# cne=ex2.personnes.where(initiale: 'FMR').first
# jours= [2, 3, 4, 7, 8, 9, 10, 11, 14, 15, 16, 17, 18, 21, 22, 23, 24, 25, 28, 29, 30, 31, 32, 35, 36, 37, 38, 39, 42, 43, 44, 45, 46, 49, 50, 51, 52, 53, 56, 57, 58, 59, 60, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 77, 78, 79, 80, 81, 84, 85, 86, 87, 88, 92, 93, 94, 95, 98, 99, 100, 101, 102, 105, 106, 107, 108, 109, 112, 113, 114, 115, 116, 119, 120, 122, 123, 126, 127, 130, 133, 134, 135, 136, 137, 141, 142, 143, 144, 147, 148, 149, 150, 151, 154, 155, 156, 157, 158, 161, 162, 163, 164, 165, 168, 169, 170, 171, 172, 175, 176, 177, 178, 179, 182, 183, 184, 185, 186, 189, 190, 191, 192, 193, 196, 197, 198, 199, 200, 203, 204, 205, 206, 207, 210, 211, 212, 213, 214, 217, 218, 219, 220, 221, 224, 225, 226, 228, 231, 232, 233, 234, 235, 238, 239, 240, 241, 242, 245, 246, 247, 248, 249, 252, 253, 254, 255, 256, 259, 260, 261, 262, 263, 266, 267, 268, 269, 270, 273, 274, 275, 276, 277, 280, 281, 282, 283, 284, 287, 288, 289, 290, 291, 294, 295, 296, 297, 298, 301, 302, 303, 304, 308, 309, 310, 311, 312, 316, 317, 318, 319, 322, 323, 324, 325, 326, 329, 330, 331, 332, 333, 336, 337, 338, 339, 340, 343, 344, 345, 346, 347, 350, 351, 352, 353, 354, 357, 358, 360, 361, 364, 365]
# puts "Nombre de jours=#{jours.count}"
# total=0
# jours.each do |jour|
# 	resultat=cne.activites.where(jour: jour).inject(0){|sum,activite| sum=sum+activite.poids}
# 	puts "r=#{resultat}"
# 	total=total+resultat
# end

# puts "resultat = #{total}"

