//
//  PopMovies.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 25.02.2023.
//

import Foundation

struct PopMovies : Codable { // web servisten veri çekerken codable kullanırsak işlemler kısalır
    
    var page : Int? //optional - data gelebilir de gelmeyebilir de. gelirse hazırlıklı ol
    var results : [PopMovResults]?  //Her sayfada gelen 20 filmlik veriyi temsil ediyor
    var total_results : Int?
    var total_pages : Int?
}
