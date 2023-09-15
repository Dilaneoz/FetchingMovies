//
//  LikedMovies.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 26.02.2023.
//

import Foundation
struct LikedMovies : Codable {
    //singleton design
    // struct ların içerisinde bir değişkenin değerini değiştirmek istiyorsak struct lar içinde fonksiyonlar tanımlayabiliriz
        // struct larda bir değişkenin değerini değiştirmek istiyorsak o değişkenin başında mutating kullanılır, class larda bunu @objc kullanarak yaptık
        // her detayına gittimiz filmde LikedMovies struct ına erişmek isteyeceğiz. her seferinde bu struct tan bir nesne oluştur ve o nesneyle beraber bu struct ın içindeki fonksiyonlara eriş yaklaşımı doğru değil. İOS her oluşturduğumuz nesnenin ne kadar kullanılıp kullanılmadığını ölçen bir algoritmaya sahip. o nesnelerle işimiz bittiği zaman bunları telefonun ram inden kaldırır (performansın gelişmesiyle ilgili garbage collector yapısı). bu classtan nesne oluşturduysak bununla işimiz bittiğinde deconstructor dediğimiz yapıyla onun ram dan kaldırılmasını kendimiz de yönetebiliyoruz, iyi bir yazılımcı bunu yapar
        //singleton design pattern ile bu nesne hiç oluşmadıysa bir kere oluşmasını isteriz ve tekrar bu nesneyle işim olduğunda var olan nesne üzerinden işlem yürütürüz (shared)
        // verileri UserDefaults ta saklamak yerine ileride hoca sqlite ve reem diye bir veritabanı gösterecek. bununla stringe çevirmeden bir database e yazıyormuş gibi yapıcaz. ama kurumsal uygulamalarda ve basit uygulamalarda bu user defaults yapısı karşımıza çıkabilir
    
    static var shared = LikedMovies()
    
    var begenilenFilmArray : [PopMovResults] = [] // içi boş bir array tanımladık
    
    
    func isLiked(movie :PopMovResults)-> Bool { // ilgili film beğenildi mi beğenilmedi mi. kendisine gelen film daha önce bu array in içerisinde var mıydı yok muydu
        
        if begenilenFilmArray.contains(where: {$0.id == movie.id}) // gelen movie id o anki döngüdeki id ile eşit mi
        {
            return true // like lamak istediğimiz film listede daha önce var ise
        }
        else
        {
            return false // like lamak istediğimiz film listede yoksa
        }
    }
    
    
    mutating func like(movie : PopMovResults) {
        // bu array e beğenmek istediğimiz filmi ekliyoruz
        // like lamak istediğimiz film eğer daha önce listeye eklendiyse listeye eklemeden fonksiyondan çık
        //like lamak istediğimiz film eğer daha önce listeye eklendiyse
        // listeye eklemeden fonksiyondan çık
        if isLiked(movie: movie) // gelen filmin daha önce bu array in içinde olup olmadığını kontrol ediyoruz
        {
            return // bir program return komutunu gördüyse aşağıdaki kodlar devreye girmez. yani film listede varsa aşağıdaki kodlar çalışmayacak yoksa çalışacak
        }
        begenilenFilmArray.append(movie)
        //dosyaya kaydedilecek fonksiyon burada çağrılacak
        begenilenFilmleriKaydet() // beğendiğim filmler UserDefaults ta saklansın
    }
    
    mutating func unlike(movie : PopMovResults) { // detayına gitmiş olduğumuz filmi unlike yapıyoruz
        if !isLiked(movie: movie) // filmi önceden like ladıysam
        {
            return
        }
        begenilenFilmArray = begenilenFilmArray.filter({$0.id != movie.id}) // [1,3,4] 1, 3 ve 4 numaralı film [3,4] 3 ve 4 numaralı film. id, gelen film id sine eşit değilse, eşleşmeyen kaydı dönücek. unlike etmek istediğim filmin id si 1 ise eşleşmeyen kayıtları filtreleyerek dönücek. yani önceden 1, 3 ve 4 numaralı filmleri beğenmiştim, 1. filmi çıkarıyorum ve geriye 3 ve 4 kalıyor //[1,3,4]  [3,4]
        begenilenFilmleriKaydet() // ve kaydedecek
    
    }
    
    
    //Begenilen Filmleri UserDefaults içinde saklayacak
    func begenilenFilmleriKaydet() { // bir array vericez ve bu arrayi de string e dönüştürmesi gerekecek. bunu aşağıdaki arrayToString fonksiyonunda yapıyoruz. bu fonksiyonda da bunu string olarak userDefaults un içinde saklayacak
        let str = arrayToString(array: begenilenFilmArray) // arrayToString fonksiyonuna begenilenFilmArray ini veriyoruz
        UserDefaults.standard.set(str,forKey: "SavedMovies") // beğenilen filmleri userDefaults ta saklayacak
    }
    
    mutating func begenilenFilmleriYukle() { // aşağıda string ten array e dönüştürdükten sonra, dönüştürdüğümüz array i bir fonksiyon ile bu struct ta kullanmak gerek. bunu da bu fonksiyonda yapıyoruz
        if let kaydedilenStringData = UserDefaults.standard.object(forKey: "SavedMovies") as? String { // UserDefaults tan aldığı beğenilen filmleri string olarak aldık
            let begenilmisFilmler = self.stringToArray(str: kaydedilenStringData) // bu string datayı da array a dönüştürüyoruz
            self.begenilenFilmArray = begenilmisFilmler // begenilenFilmArray e begenilmisFilmler i aktar
        }
    }
    
    //kendisine içinde film tipinde bir array gönderdiğimizde bu array i String e çevirecek
    func arrayToString(array : [PopMovResults])-> String {
        let encoder = JSONEncoder() // şifreli bir şekilde saklaması için encoder ı kullanırız. hem json formatında hem de şifreleyerek oluşturacak
        if let jsonData : Data = try? encoder.encode(array) // yukarıdan gelen array i şifreleyerek jsonData diye bir değişkende tut
        {
            let dataString = String(data:jsonData, encoding: String.Encoding.utf8) // jsonData değişkenini bir string e dönüştür ve encoding ile de içerisinde encode edilmemiş harfler bulunursa onları bu formata uygun şekilde dönüştür. utf8 in amacı json  içindeki anlaşılamaz harfleri (çince vs.) de string e dönüştürmek
            return dataString!
        }
        return "" // hiçbişi yapamazsa boş bir string döndür
    }
    // filmleri array e kaydettik ama kaydedilmiş olan verileri bize gösterecek yukarıdakinin tersi bir mekanizma yapmak gerekiyor. favorites a tıkladığımızda bize kaydedilmiş filmleri gösterecek
    //string olarak kaydedilmiş veriyi bu fonksiyon ile içine film tipinde veri alan bir array e dönüştürüp bunu geri döndürür
    func stringToArray(str : String) -> [PopMovResults] {
        let decoder  = JSONDecoder() // encode ile şifrelemiş olduğumuz şeylerin JSONDecoder ile şifresini çözüyoruz
        if let gelenData = str.data(using: .utf8) {// utf8 formatında kaydetmiş olduğumuz string datayı gelenData diye bir değişkene atadık
            let jData = try? decoder.decode([PopMovResults].self,from: gelenData) // bunu da try catch yapısıyla decode diyerek şifresini çözüyoruz ve gelen stringi de array e dönüştürüyoruz
            return jData ?? [] // hiçbir şey yapamazsan boş bir array dön
        }
        return [] // bütün bunların sonucunda da bir sorun olursa yine boş bir array dön
    }
}
