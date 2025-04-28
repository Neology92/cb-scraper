# CB Scraper

An easy contact data collection tool for Chaturbate streamers, designed for professional outreach.

## Purpose

This project was created on request to automate the process of collecting contact information from Chaturbate streamers for **professional purposes** and **collaboration offers**. Instead of manually searching for contact info one by one, this scraper pulls data automatically and stores it in a database, making it easier and faster to reach out to streamers for business-related inquiries.

## Built with

- **Elixir** – A dynamic, functional language designed for creating scalable and maintainable applications.
- **Floki** – A lightweight HTML parser for Elixir, used for scraping and parsing the web pages.
- **HTTPoison** – A simple HTTP client for Elixir, used to make requests to Chaturbate.
- **Concurrency Processing** – Utilizes Elixir’s lightweight processes for concurrent scraping of multiple pages to optimize performance and efficiency.

## How It Works

The **CB Scraper** works with a multi-threaded approach:

- **One thread** collects data about Chaturbate streamers sequentially and adds it to the database.
- **A second thread** ensures that any missing information for streamers is updated by going through records that haven't been fully updated yet.

Running the scraper multiple times will **not result in duplicate records**. The system prioritizes updating records that have **not been fully updated** in the database, ensuring that the latest available information is always collected without redundancy.

### Rate Limiting & Intervals

To avoid being flagged as a bot by Chaturbate, the scraper includes built-in **time intervals** between requests. These intervals are necessary to mimic human behavior and prevent the site from blocking access. Although this slightly slows down the scraping process, it is an **essential feature** to ensure continued access to Chaturbate.

The time intervals have been fine-tuned through **extensive testing and observation** of the delays coded into Chaturbate's backend systems, ensuring that the scraper operates safely and effectively without triggering restrictions.


## Getting Started

To get the scraper up and running, follow these steps:

### Prerequisites

1. **Install PostgreSQL** on your machine for database setup.

2. **Install Elixir** and **Mix** if not already installed:  
   [Install Elixir](https://elixir-lang.org/install.html)

### Setup

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/cb-scraper.git
    ```

2. Navigate to the project folder:
    ```bash
    cd cb-scraper
    ```

3. Install dependencies:
    ```bash
    mix deps.get
    ```

4. Set up the PostgreSQL database by configuring your credentials in the `config.exs` file:
    - `username`: Your Postgres username
    - `password`: Your Postgres password

5. Create and migrate the database:
    ```bash
    mix ecto.create
    mix ecto.migrate
    ```

6. Start the app:
    ```bash
    iex -S mix
    ```

Once running, the scraper will collect data in the background and store it in the database.

## How It Works

The **CB Scraper** collects data by making concurrent requests to Chaturbate streamers' pages. Using **Floki**, it scrapes the necessary contact information from each page, and **HTTPoison** handles the HTTP requests. The app makes efficient use of Elixir's concurrency model to handle multiple requests simultaneously, improving the speed of data collection.

## License

This project is licensed under the MIT License.
