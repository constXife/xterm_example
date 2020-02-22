<template>
    <div id="terminal"></div>
</template>

<script>
    import { Terminal } from 'xterm';
    import { FitAddon } from 'xterm-addon-fit';
    import 'xterm/css/xterm.css';

    export default {
        data () {
            return {
                output: ''
            }
        },
        mounted() {
            let term = new Terminal();
            let fitAddon = new FitAddon();
            term.loadAddon(fitAddon);
            term.open(document.getElementById('terminal'));
            fitAddon.fit();

            term.prompt = () => {
                term.write('\r\n$ ');
            };

            this.$options.sockets.onmessage = (receivedData) => {
                let parsed = receivedData.data;

                parsed.match(/[^\r\n]+/g).forEach(function(line) {
                    term.writeln(line);
                });

                term.prompt();
            };

            term.prompt();
            term.focus();

            let input = '';

            term.onKey((e) => {
                const ev = e.domEvent;
                const printable = !ev.altKey && !ev.ctrlKey && !ev.metaKey;

                if (ev.keyCode === 13) {
                    this.$socket.send(input);
                    input = '';
                    term.writeln('');
                } else if (ev.keyCode === 8) {
                    // Do not delete the prompt
                    if (term._core.buffer.x > 2) {
                        term.write('\b \b');
                        input = input.slice(0, -1);
                    }
                } else if (printable) {
                    input += e.key;
                    term.write(e.key);
                }
            });
        },
        destroyed() {
            delete this.$options.sockets.onmessage;
        }
    }
</script>

<style lang="scss">

</style>
