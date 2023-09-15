//
//  HomeViewController.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 25.02.2023.
//


import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SVProgressHUD
import SwiftSpinner

// bazen yukarıdaki kütüphaneler yüklenmeyebilir bu durumda tekrar pod install ya da pod deintegrated yapmak gerek
// mainde her view controller da collection view e tıklayıp üçgene gelip min spacing te for cells i 0 yapmamız lazım boşlukların gitmesi için. 3 sıra film gösterilmesi için de ayarlardan items ı 3 yapıyoruz

class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    var isLoadingMore = false // aşağı doğru indikçe daha fazlası diye çıkan kısım
    var movie : PopMovies?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.delegate = self // collection view a eklenecek veriden ve yaptığı işlemden, self diyerek home view controller ın haberdar olmasını sağlarız
        homeCollectionView.dataSource = self
        self.getJSON()
    }
    
    
    func getJSON(){
        // SwiftSpinner.show("Connecting to satellite...")
        Alamofire.request("https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1").responseJSON {
            (response) -> Void  in // url den gelen datayı response objesi içinde tut
            
            if response.result.isFailure { // istediğim sonuç var mı diye kontrol
                print("Hata olustu")
            } else {
                guard let gelenData = response.data else {return } // gelen yanıtın içerisinde istediğimiz data var mı kontrol ederiz. guard let yapısı if else koşullarını kontrol etmemizi ve if else in daha performanslı çalışmasını sağlar. if else te yaşanılan sorunları daha iyi yöntebilmemizi sağlar
                
                do { // data düzgün bir şekilde geldiyse aşağıdakileri yap
                    let decoder = JSONDecoder() // daha önce web servisten veri çekerken uzunca yaptığımız işlemleri decoder ile kısaltabiliriz
                    let jData = try decoder.decode(PopMovies.self, from: gelenData) // decoder nesnesinin decode fonksiyonu bizden gelenDatayı istiyor. gelenData yı alıyor ve PopMovies e uygun hale getiriyor ve json daki veriyi eşleştiriyor. artık jData ile bu data içerisindeki filmlere erişebilicez
                    
                    self.movie = jData // movie nin içerisinde web servisteki bütün veriler var
                    DispatchQueue.main.async { // senkron ve asenkron dediğimiz iki tane programlama çeşiti vardır. senkron programlamada 3 tane fonksiyon varsa örneğin 3e gitmeden önce 1 ve 2 çağırılır. asenkron programlamada, starbucks örneği verilir. birinin siparişi hazırlanırken diğerlerininki de hazırlanır yani bir sıra yoktur. asenkronda da işlem sırasının önemi yoktur. burada da asenkron yapısını kullanırsak arka planda asenkron bir şekilde resimlerin çizilmesini sağlarız
                        
                        self.homeCollectionView.reloadData() // bunu yazmazsak veriler yüklenmez. arka planda cell leri oluştururken ekranı bloklamadan daha hızlı yapmayı sağlar
                        print(self.movie?.results?.count ?? 0 ) // hangi veriler elimizde görmek için
                        print(self.movie?.page ?? 0 ) // ?? 0 dememizin sebebi, öncekileri optional olarak tanımladığımız için bir veri gelicek mi gelmiycek mi emin olamıyor ve gelmezse ne olacağını bildirmemizi istiyor
                    }
                    
                }
                catch let error { // gelen dataları işlerken hata olursa konsola error yazdıracak
                    print("Error", error)
                }
            }
            // SwiftSpinner.hide()
        }
        
    }
    
    func loadMoreJSON() // bize 1den sonraki sayfaları getirecek olan fonksiyon
    {
        if self.isLoadingMore
        {
            return
        }
        self.isLoadingMore = true // daha fazla sayfa göstermesi için bunu true yapıyoruz
        let aktifSayfa = self.movie?.page // hangi sayfayı talep ediyor onun da datasını tutmak gerek
        print(aktifSayfa ?? 0 )
        SwiftSpinner.show("yükleniyor") // sayfa aşağı inerken animasyonlu bir şekilde yükleniyor çıkar
        
        // getJSON fonksiyonundaki kodları kopyalıyoruz. küçük değişiklikler var
        Alamofire.request("https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(aktifSayfa!+1)").responseJSON {
            (response) -> Void  in
            
            if response.result.isFailure {
                print("Hata olustu")
            } else {
                guard let gelenData = response.data else {return }
                
                do {
                    let decoder = JSONDecoder()
                    let jData = try decoder.decode(PopMovies.self, from: gelenData)
                    DispatchQueue.main.async {
                        //2. sayfadaki gelen diğer 20 kayıt var olan results array ine eklenecek
                        self.movie?.results?.append(contentsOf: jData.results ?? []) // jData dan gelen results taki dataları ekliyoruz. hiçbi kayıt yoksa array i temizler
                        // 2. sayfadaki gelen diğer 20 kayıt, var olan results array ine eklenecek

                        self.homeCollectionView.reloadData()
                        self.isLoadingMore = false // 2. sayfadaki işlem bittiği zaman 3. sayfaya geçip geçmeyeceğini bilmiyoruz. 2. sayfanın sonuna geliyorsa 3. sayfaya geçecek. o yüzden true yu false a çekmek gerek
                    }
                    
                }
                catch let error {
                    print("Error", error)
                }
                
                
            }
            SwiftSpinner.hide()
        }
    }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.movie?.results?.count ?? 0
        }
        
        
        //gizli bir for döngüsü
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell // HomeCollectionViewCell den bir nesne oluşturduk
            
            
            if let nextMovie = self.movie?.results?[indexPath.row] { // 0. elemandan başlayarak web servisteki datalardan sırasıyla nesne oluşturacak
                // bir koşul içerisinde ilgili nesnenin içerisine özellikler yapılacaksa if let kullanmak gerekiyor. tek satırda bir şey var mı yok mu kontrol etmek gerekiyorsa guard let daha mantıklı
                
                cell.homeMovieName.text =  nextMovie.title
                if let resimAdi = nextMovie.poster_path {
                    let resimYolu = URL(string: "https://image.tmdb.org/t/p/w500"+resimAdi)
                    cell.homeMovieImage.af_setImage(withURL : resimYolu!)
                }
                
            }
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return CGSize(width: view.frame.size.width / 3, height: 200)
        }
        
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell : UICollectionViewCell, forItemAt indexPath:IndexPath)
        {
            print(indexPath)
            if indexPath.row == (self.movie?.results?.count)! - 4
            { // 20 kayıttan 16. sını gördüğümüzde ikinci sayfaya gitmek istediğimizi bildiriyoruz
                loadMoreJSON() // ikinci sayfaya gitmek istiyorum
                self.movie?.page? += 1
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let navStoryboard = UIStoryboard(name: "Main", bundle: nil) // hangi storyboard da olduğumuzu bildiriyoruz
        let movieDetailViewController = navStoryboard.instantiateViewController(withIdentifier: "MovieDetailViewControllerID") as! MovieDetailViewController // gitmek istediğimiz (MovieDetailViewController) view controller dan bir nesne oluşturduk
        
        
        if let currentMovie = self.movie?.results?[indexPath.row]
        { // o an tıklanılan filmden bir nesne oluşturduk
            movieDetailViewController.movieResultData  = currentMovie
        } // bir sayfadan başka bir sayfaya obje gönderiyoruz
        
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
       }
        
        
    }
    

