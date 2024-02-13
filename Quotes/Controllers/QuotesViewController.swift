//
//  QuotesViewController.swift
//  Quotes
//
//  Created by Adriano Rodrigues Vieira on 04/02/24.
//

import UIKit
import SkeletonView

final class QuotesViewController: UIViewController {
    private let aView = QuotesView()
    var quotedWasFetched = false

    private let apiKey = "6BsMKVg7d0pN6KpWdomblFMLZWkvMVRBDF7N16G4"

    override func loadView() {
        super.loadView()
        view = aView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setup()
    }

    private func setup() {
        aView.button.setTitle("Get quote!", for: .normal)
        aView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        aView.quoteLabel.text = "No quote..."
    }

    @objc private func buttonTapped() {
        quotedWasFetched = false
        aView.quoteLabel.showSkeleton()
        aView.authorLabel.isHidden = false
        aView.authorLabel.showSkeleton()

        let urlPath = "https://quotes.rest/qod?api_key=\(apiKey)"

        guard let url = URL(string: urlPath) else { return }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request, printingJson: true) { data, response, error in
            if let error {
                Task {
                    await self.fillLabels(with: "Ops! Something wrong occurs: \(error.localizedDescription)")
                    return
                }
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 429 {
                Task {
                    await self.fillLabels(with: "Too many requests. Try again later")
                    return
                }
            }

            if let data {
                do {
                    let decoded = try JSONDecoder().decode(QuotesModel.self, from: data)                    

                    Task {
                        guard let quoteModel = decoded.contents?.quotes?.first, let quote = quoteModel.quote else {
                            let error = "Error fetching quote"
                            await self.fillLabels(with: error)
                            return
                        }

                        await self.fillLabels(with: quote, of: quoteModel.author)
                    }
                } catch {
                    Task {
                        await self.fillLabels(with: "Ops! Something wrong occurs: \(error.localizedDescription)")
                    }
                }
            } else {
                Task {
                    await self.fillLabels(with: "Ops! Something wrong occurred...")
                }
            }
        }.resume()
    }

    private func fillLabels(with quote: String, of author: String? = nil) {
        guard !quotedWasFetched, !quote.isEmpty else { return }

        quotedWasFetched = true

        DispatchQueue.main.async {
            self.aView.quoteLabel.hideSkeleton(transition: .crossDissolve(0.25))
            self.aView.authorLabel.hideSkeleton(transition: .crossDissolve(0.25))
            self.aView.quoteLabel.text = quote
            if let author {
                self.aView.authorLabel.text = author
            } else {
                self.aView.authorLabel.isHidden = true
            }
        }
    }
}

