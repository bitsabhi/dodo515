module.exports = {
  apps: [{
    name: 'dodo',
    script: 'server.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 9999
    },
    env_production: {
      NODE_ENV: 'production',
      PORT: 9999
    },
    error_file: './logs/dodo_err.log',
    out_file: './logs/dodo_out.log',
    log_file: './logs/dodo_combined.log',
    time: true,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G'
  }]
}
