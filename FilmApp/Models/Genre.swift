//
//  Genre.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 11.03.2023.
//

import Foundation

// web servisten film kategorilerini çekicez
struct Genre : Codable {
    
    //içine Genres Tipinde veri alan bir array oluşturduk.
    var genres : [Genres]?
}

//bize gelen rest servisindeki her bir kategoriyi temsil eden modelimiz

struct Genres : Codable {
    var id : Int?
    var name : String?
    
}
