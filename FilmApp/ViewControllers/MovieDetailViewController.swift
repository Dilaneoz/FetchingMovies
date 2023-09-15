//
//  MovieDetailViewController.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 26.02.2023.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    
    @IBOutlet weak var filmImage: UIImageView!
    
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var totalView: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    
    
    @IBOutlet weak var textDate: UILabel!
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var textVote: UILabel!
    
    
    var unlikeIMG  = UIImage(named:"unlike") // içi boş kalp
    var likedIMG = UIImage(named: "liked") // içi dolu kalp
    
    //Detayına tıklanılan filmin tüm datasını bu objeye aktaracağız
    var movieResultData : PopMovResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true) // üstte navigation sütunu oluşur
        self.title = movieResultData?.title // title a filmin adını yazdır
        releaseDate.text = movieResultData?.release_date
        //ternary operator
        totalView.text = String(movieResultData?.popularity ?? 0)
        voteAverage.text = String(movieResultData?.vote_average ?? 0)
        movieOverview.text = movieResultData?.overview
        self.checkLikeButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated:true)
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black // arka plan siyah
            nav?.tintColor = UIColor.white // yazılar beyaz
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange] // başlık turuncu
    }
    
    
    //
    func checkLikeButton() { // kalp butonunun tıklanıp tıklanmadığını kontrol etmek için bir fonksiyon yazıyoruz
        // bu sayfa yüklenirkenki kısım. sayfanın detayına gelindiğinde ne gösterileceğine bu fonksiyon karar verecek
        
        if LikedMovies.shared.isLiked(movie: self.movieResultData!)
        { // detayına gelinen filmin kendisi daha önceden beğenildi mi beğenilmedi mi
            let liked =  UIBarButtonItem(image:likedIMG , style: .done, target: self, action: #selector(addFavorite)) // kodla navigasyon çubuğu içinde item ı oluşturuyoruz. bunu mainde bar button item ile de oluşturabiliriz
            // bu daha önce beğenilmemiş bir filmse beğen
             navigationItem.rightBarButtonItems = [liked]
        } // yukarıda oluşturduğum nesneyi (liked) navigasyon çubuğunun sağına ekle
        else
        {
            let unlike =  UIBarButtonItem(image:unlikeIMG , style: .done, target: self, action: #selector(addFavorite)) // daha önce beğenilmişse unlike yap
             navigationItem.rightBarButtonItems = [unlike]
        }
        
      
    }
    
    
    @objc func addFavorite(){ // beğenip beğenmemeye bu fonksiyon karar verecek.
           
        if LikedMovies.shared.isLiked(movie: self.movieResultData!) { // eğer daha önce bir film beğenildiyse
            LikedMovies.shared.unlike(movie: self.movieResultData!) // o filmi unlike et
            checkLikeButton() // bu fonksiyon unlike halini gösterir
        }
        else
        {
            LikedMovies.shared.like(movie: self.movieResultData!) // daha önce bu film beğenilmediyse beğen
            checkLikeButton()
        }
        }

  
}
