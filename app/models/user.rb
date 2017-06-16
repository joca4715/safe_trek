class User < ApplicationRecord
  has_secure_password

  has_many :locations

  has_many :comments, as: :commentable, dependent: :destroy

  validates :name, presence: true

  validates :username,
  presence: true,
  uniqueness: true

  validates :email,
  presence: true,
  uniqueness: { case_sensitive: false },
  format:
  {
    with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
    on: :create
  }

  validates :password,
  presence: true,
  length: 6..20,
  confirmation: true

  validates :current_city,
  presence: true

  validates :current_state,
  format:
  {
    with: %r{\A(?:(A[KLRZ]|B[C]|C[AOT]|D[CE]|FL|GA|HI|I[ADLN]|K[SY]|LA|M[ADEHINOST]|N[CDEHJMVY]|O[HKR]|P[AR]|RI|S[CD]|T[NX]|UT|V[AIT]|W[AIVY]))\z}, message: 'must be formatted as state initials. e.g. CA for California',
    :on => :create
  }

  validates :current_country,
  presence: true,
  format:
  {
    with: %r{\A(?-i:A[DEFGILMNOQRSTUWZ]|B[ABDEFGHIJMNORSTVWYZ]|C[ACDFGHIKLMNORSUVXYZ]|D[EJKMOZ]|E[CEGHRST]|F[IJKMOR]|G[ABDEFHILMNPQRSTUWY]|H[KMNRTU]|I[DELNOQRST]|J[MOP]|K[EGHIMNPRWYZ]|L[ABCIKRSTUVY]|M[ACDGHKLMNOPQRSTUVWXYZ]|N[ACEFGILOPRUZ]|O[M]|P[AEFGHKLMNRSTWY]|QA|R[EOUW]|S[ABCDEGHIJKLMNORTVYZ]|T[CDFGHJKLMNORTVWZ]|U[AGMSYZ]|V[ACEGINU]|W[FS]|Y[ET]|Z[AMW])\z}, message: 'must be formatted as US for United States',
    :on => :create
  }

  validates :bio,
  presence: true

end
