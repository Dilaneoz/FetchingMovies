//
//  SearchViewController.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 25.02.2023.
//

import UIKit
import Alamofire
import AlamofireImage

// SQLite verileri tek bir platformlar arası dosyada saklar. özel bir sunucu veya özel dosya sistemi olmadığından sqlite ı "dağıtmak" kitaplığını bağlamak ve yeni bir normal dosya oluşturmak kadar kolaydır. özetle sqlite uygulama içinde verilerimizi saklayabileceğimiz ufak bir database dir. bir dosyadır aslında ve içine kayıtlar eklenir.

// Realm açık kaynaklı veritabanı yönetim sistemidir. Realm veritabanı kullanımı kolay, sqlite veritabanına göre query oluşturma konusunda daha performanslı bir yapıya sahip. Realm, java swift objective-c javascript ve .net gibi birçok yazılıma da destek vermektedir. doğrudan telefonların tabletlerin içinde çalışan bir mobil veritabanıdır ve son derece zengin bir özellik setini korurken, genel işlemlerde sqlite tan bile daha hızlıdır

class SearchViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource{
  
    @IBOutlet weak var searchTableView: UITableView!
    var movie : PopMovies?
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController // navigation item a search bar ekleme
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else {return } // search bar ın içine text yazılacak. eğer bir değer gelmezse return
        print(text)
        let searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503&language=en-US&query=\(text)"
        Alamofire.request(searchUrl).responseJSON { response -> Void in
            if response.result.isFailure {
                print("Hata olustu")
            } else {
                guard let gelenData = response.data else {return }
                
                do {
                    let decoder = JSONDecoder()
                    let jData = try decoder.decode(PopMovies.self, from: gelenData)
                    
                    self.movie = jData
                    DispatchQueue.main.async {
                        
                        self.searchTableView.reloadData()
                        
                    }
                
                }
                catch let error {
                    print("Error", error)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movie?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchTableViewCell
        
        if let siradakiFilm = self.movie?.results?[indexPath.row]{
            tableCell.searchMovieName.text = siradakiFilm.title
            tableCell.searchReleaseDate.text = siradakiFilm.release_date
            tableCell.searchTotalView.text = String(siradakiFilm.popularity)
            tableCell.searchVoteAvarage.text = String(siradakiFilm.vote_count ?? 0)
            
            if let resimAdi = siradakiFilm.poster_path {
                let resimYolu = URL(string: "https://image.tmbd.org/t/p/w500"+resimAdi)
                tableCell.searchFilmImage.af_setImage(withURL: resimYolu!)
            }
        }
        return tableCell
    }
    
}
