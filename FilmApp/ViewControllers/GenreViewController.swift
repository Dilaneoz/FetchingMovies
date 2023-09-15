//
//  GenreViewController.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 11.03.2023.
//

import UIKit
import Alamofire
class GenreViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    var genreID : Int?
    var movie : PopMovies? // PopMovies tipinde filmler gelecek
    var isLoadingMare = false
    var categoryName = "" // title da kategorinin adını göstericez
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = categoryName
        // Do any additional setup after loading the view.
        self.LoadMovies() // sayfa yüklenirken filmleri çağırıyoru<
    }
    
    
    func LoadMovies() // filmleri bu fonksiyon ile getiriyoruz
    {
        if let gelenKategoriID = self.genreID {
            let url = "https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=\(String(describing: gelenKategoriID))"
            
            Alamofire.request(url).responseJSON {(response) -> Void in
                if response.result.isFailure {
                    print("Error")
                }
                else {
                    guard let gelenVeri = response.data else{return}
                    do
                    {
                        let decoder = JSONDecoder()
                        //[Film,Film,Film,Film,Film]
                        let jData = try decoder.decode(PopMovies.self,from:gelenVeri)
                        self.movie = jData
                        self.genreCollectionView.reloadData()
                    }
                    catch let err {
                        print("Error", err)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movie?.results?.count ?? 0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenreCollectionViewCell
        
        if let siradakiFilm = self.movie?.results?[indexPath.row]
        {
            cell.genreFilmName.text = siradakiFilm.title
            if let resimAdi = siradakiFilm.poster_path {
                let resimYolu = URL(string: "https://image.tmdb.org/t/p/w500"+resimAdi)
                cell.genreImageView.af_setImage(withURL : resimYolu!)
            }
        }
        
        return cell
    }
    
   

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.size.width / 3, height: 200)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let navStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailViewController = navStoryboard.instantiateViewController(withIdentifier: "MovieDetailViewControllerID") as! MovieDetailViewController
        
        
        if let currentMovie = self.movie?.results?[indexPath.row]
        {
            movieDetailViewController.movieResultData  = currentMovie
        }
        
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
       }
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
