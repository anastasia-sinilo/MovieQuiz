import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol!
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetFrame()
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - Private functions
    
    private func resetFrame() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func show(quiz step: QuizStepViewModel) {
        resetFrame()
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showResult(quiz result: QuizResultsViewModel) {
        let model = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText) {[weak self] in
            guard let self = self else {return}
                self.presenter.restartGame()
        }
        alertPresenter.show(in: self, model: model)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            presenter.restartGame()
        }
        alertPresenter.show(in: self, model: model)
    }
}
