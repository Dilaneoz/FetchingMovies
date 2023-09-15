//
//  CategoriesViewController.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 25.02.2023.
//

import UIKit
import Alamofire
class CategoriesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    @IBOutlet weak var kategoriCollectionView: UICollectionView!
    
    
    //rest api den gelen kategorileri tutacak
    var movieGenre : Genre?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getJsonCategories()
    }
    
    func getJsonCategories()
    {
        // web servisten gelen kategori verilerini çekiyoruz
        Alamofire.request("https://api.themoviedb.org/3/genre/movie/list?api_key=b155b3b83ec4d1cbb1e9576c41d00503&language=en-US").responseJSON {
            (response) -> Void  in
            
            if response.result.isFailure { // web servisten hata gelirse yazdır
                print("Error")
            }
            else {
                guard let data = response.data else{return} // hata oluşmadıysa response tan gelen dataları işlemeye başla. sorun varsa onları işlemeden uygulamadan çık (return)
                do // do catch yapılarıyla gelen dataları işliyor
                {
                    
                    let decoder = JSONDecoder() // json içindeki datalar önce bizim yapımıza uygun hale getiriliyor
                    //{"id":28,"name":"Action"},{"id":12,"name":"Adventure"} böyleyken, [Genre,Genre] bu şekilde objelere dönüşerek gelicek veri
                    let jData = try decoder.decode(Genre.self,from:data)
                    self.movieGenre = jData
                    self.kategoriCollectionView.reloadData() // dataları çağırmış olsakta reloadData demezsek datalar gelmez
                    
                }
                catch let error {
                    print("Error", error)
                }

            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //rest apiden gelen kayıt sayısı kadar eleman gösetereceksin
    
        return self.movieGenre?.genres?.count ?? 0
        
    }
    
    
    
    
    //gizli bir for döngüsü
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kategoriCell", for: indexPath) as! KategoriCollectionViewCell
        if let siradakiKategori = self.movieGenre?.genres?[indexPath.row]
        {
            cell.kategoriImageLabel.text = siradakiKategori.name
            let stringBosluk = nameTrim(siradakiKategori.name ?? "") // gelen kategori isimlerinde boşluk varsa kaldır diyoruz çünkü nameTrim fonksiyonuyla boşlukları kaldırılmış geliyor
            if let categoryEnum : MovieBanner = MovieBanner(rawValue: stringBosluk)
            {
                getImage(categoryEnum, cell)
            }
            
            
        }
        
        return cell
        
    }
    // tek tek değişken oluşturmak yerine enum kullanmak işimizi kolaylaştırır. Enumeration numaralandırma anlamına gelir
    enum MovieBanner : String {
        case Action
        case Adventure
        case Animation
        case Comedy
        case Crime
    }
    func nameTrim(_ name:String) -> String {
        let trimmed = name.replacingOccurrences(of: " ", with: "") // web servisteki datalar arasındaki boşlukların kaldırılması için gereken fonksiyon
        return trimmed
    }
    
    func getImage(_ genreName: MovieBanner, _ cell : KategoriCollectionViewCell) { // kategorinin ismine göre karşılığı olan resmi gönder (isimler aynı yazılır)
        switch genreName {
        case .Action:
            let image = UIImage.init(named: genreName.rawValue)
            cell.kategoriImageView.image = image
        case .Adventure:
            let image = UIImage.init(named: genreName.rawValue)
            cell.kategoriImageView.image = image
        case .Animation:
            let image = UIImage.init(named: genreName.rawValue)
            cell.kategoriImageView.image = image
        case .Comedy:
            let image = UIImage.init(named: genreName.rawValue)
            cell.kategoriImageView.image = image
        case .Crime:
            let image = UIImage.init(named: genreName.rawValue)
            cell.kategoriImageView.image = image
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let navStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let genreViewController = navStoryBoard.instantiateViewController(withIdentifier: "GenreViewControllerID") as! GenreViewController
        
        if let category  = self.movieGenre?.genres?[indexPath.row]
        {
            let id = category.id
            genreViewController.genreID = id
            genreViewController.categoryName = category.name!
            
        }
        
        self.navigationController?.pushViewController(genreViewController, animated: true)
    }

}
