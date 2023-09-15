//
//  FavoriViewController.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 25.02.2023.
//

import UIKit
import Alamofire
import AlamofireImage


class FavoritesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LikedMovies.shared.begenilenFilmleriYukle()
        print(LikedMovies.shared.begenilenFilmArray.count)
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LikedMovies.shared.begenilenFilmArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: "favoritesCell", for: indexPath) as! FavoritesCollectionViewCell // burada yapılan aslında şu : var cell = favoritesCollectionViewCell(). favoritesCollectionViewCell den bir nesne oluştur. ama geriye UICollectionViewCell tipinde bir nesne dönüştürüldüğü için bu şekilde yazmamızı istiyor
        let movie = LikedMovies.shared.begenilenFilmArray[indexPath.row] // sıradaki filmden nesne oluşturuyoruz
        
        
        cell.favorieMovieName.text = movie.title
        
        if let resimAdi = movie.poster_path { // burada Alomafire ı import etmek gerek
            let resimYolu = URL(string: "https://image.tmdb.org/t/p/w500"+resimAdi)
            cell.favoriImage.af_setImage(withURL : resimYolu!)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // UICollectionViewDelegateFlowLayout u yukarıda ekliyoruz. bu fonksiyon filmleri 3 sütunda göstermek için
        return CGSize(width: view.frame.size.width / 3, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // favorilerden bir filmin detayına gitmek istediğimizde yazılacak kod
        
        let navStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailViewController = navStoryboard.instantiateViewController(withIdentifier: "MovieDetailViewControllerID") as! MovieDetailViewController
        
        let seciliFilm = LikedMovies.shared.begenilenFilmArray[indexPath.row]
        movieDetailViewController.movieResultData = seciliFilm
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        
        
       }
    

    override func viewWillAppear(_ animated: Bool) {
        favoritesCollectionView.reloadData()
    }

}

