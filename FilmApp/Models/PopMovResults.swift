//
//  PopMovResults.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 25.02.2023.
//

import Foundation
//her bir filmi temsil ediyor
// PopMovResults her bir filmi temsil ediyor. Her bir film için aşağıdaki datalar dolacak. ilgili web servisin her sayfasında 20 tane film var ve toplam 37241 sayfa var
struct PopMovResults : Codable {
    // web servisteki dataları tanımlıyoruz
    var adult : Bool?
    var backdrop_path : String?
    var genre_ids : [Int]? // ilgili filmin hangi kategoride olduğunu belirtir
    var id : Int?
    var original_language : String?
    var original_title : String?
    var popularity :Double
    var poster_path : String?
    var release_date : String?
    var title : String?
    var video : Bool?
    var vote_average : Double?
    var vote_count : Int?
    var overview : String?
}
